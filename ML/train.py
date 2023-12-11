import os
import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
from model import KeypointTransformer


NORMAL_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'data', 'extract', 'normal')
FIGHT_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'data', 'extract', 'fight')
FALLDOWN_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'data', 'extract', 'falldown')

NUM_CLASSES = 3  # normal, fight, falldown
D_MODEL = 34  # Number of features per frame (17 keypoints * 2 for x and y)
NHEAD = 2  # Number of attention heads
NUM_ENCODER_LAYERS = 6  # Number of transformer encoder layers
NUM_FRAMES = 60  # Number of frames in 2 seconds
DROPOUT = 0.1  # Dropout rate

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

model = KeypointTransformer().to(device)

# Define loss function and optimizer
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

# Optionally, define a learning rate scheduler
scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=10, gamma=0.7)

# Parse train data
train_data = []
train_labels = []

def collect_trainset(data_path: str, label: int):
    for dirname in os.listdir(data_path):
        keypoints = []
        with open(os.path.join(data_path, dirname, 'keypoints.txt'), 'r') as file:
            for line in file:
                if line == '[]\n':
                    keypoints.append([0.0] * 34)
                else:
                    keypoints.append(list(map(float, line.strip()[1:-1].split(","))))
        train_data.append(keypoints)
        train_labels.append(label)

collect_trainset(NORMAL_PATH, 0)
collect_trainset(FIGHT_PATH, 1)
collect_trainset(FALLDOWN_PATH, 2)

train_data = torch.tensor(train_data)
train_labels = torch.tensor(train_labels)
train_data = train_data.permute(1, 0, 2).to(device)
train_labels = train_labels.to(device)

shuffle_indices = torch.randperm(train_data.size(1)).to(device)
shuffled_train_data = train_data[:, shuffle_indices, :]
shuffled_train_labels = train_labels[shuffle_indices]

# Separate data for each class
class_indices = [torch.where(shuffled_train_labels == i)[0] for i in range(NUM_CLASSES)]

# Split each class data into training and test
train_data_list = []
test_data_list = []
train_labels_list = []
test_labels_list = []

for idx in class_indices:
    split = int(0.8 * len(idx))
    train_data_list.append(shuffled_train_data[:, idx[:split], :])
    test_data_list.append(shuffled_train_data[:, idx[split:], :])
    train_labels_list.append(shuffled_train_labels[idx[:split]])
    test_labels_list.append(shuffled_train_labels[idx[split:]])

# Concatenate the splits to form final training and test datasets
train_data = torch.cat(train_data_list, dim=1)
test_data = torch.cat(test_data_list, dim=1)
train_labels = torch.cat(train_labels_list)
test_labels = torch.cat(test_labels_list)

# Training loop
num_epochs = 100
train_losses = []
test_losses = []

for epoch in range(num_epochs):
    model.train()
    optimizer.zero_grad()
    
    # Forward pass
    outputs = model(train_data)
    loss = criterion(outputs, train_labels)
    
    # Backward pass and optimization
    loss.backward()
    optimizer.step()
    
    train_losses.append(loss.item())
    
    # Evaluate on test data
    model.eval()
    with torch.no_grad():
        test_outputs = model(test_data)
        test_loss = criterion(test_outputs, test_labels)
        test_losses.append(test_loss.item())
    
    # Update the learning rate
    scheduler.step()
    
    print(f"Epoch [{epoch+1}/{num_epochs}], Train Loss: {loss.item():.4f}, Test Loss: {test_loss.item():.4f}")

torch.save(model.state_dict(), 'trained.pt')
print("Training completed.")
