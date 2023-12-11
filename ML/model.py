import torch.nn as nn


NUM_CLASSES = 3  # normal, fight, falldown
D_MODEL = 34  # Number of features per frame (17 keypoints * 2 for x and y)
NHEAD = 2  # Number of attention heads
NUM_ENCODER_LAYERS = 6  # Number of transformer encoder layers
NUM_FRAMES = 60  # Number of frames in 2 seconds
DROPOUT = 0.1  # Dropout rate


class KeypointTransformer(nn.Module):
    def __init__(self):
        super(KeypointTransformer, self).__init__()

        encoder_layer = nn.TransformerEncoderLayer(D_MODEL, NHEAD, dropout=DROPOUT)
        self.transformer_encoder = nn.TransformerEncoder(encoder_layer, NUM_ENCODER_LAYERS)

        self.classifier = nn.Linear(D_MODEL, NUM_CLASSES)


    def forward(self, src):
        encoded_src = self.transformer_encoder(src)
        output = self.classifier(encoded_src[-1])
        return output