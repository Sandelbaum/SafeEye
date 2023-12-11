import cv2
import torch
from model import KeypointTransformer
from ultralytics import YOLO

from queue import Queue

detect_model = YOLO('yolov8n.pt')
detect_model.to(0)

pose_model = YOLO('yolov8s-pose.pt')
pose_model.to(0)

action_model = KeypointTransformer()
action_model.load_state_dict(torch.load('trained.pt'))
action_model.eval()

frames = Queue(60)

cap = cv2.VideoCapture(0)
# cap.set(cv2.CAP_PROP_FPS, 30)

while cap.isOpened():
    ret, frame = cap.read()
    if ret:
        detect_results = detect_model(frame)
        cv2.imshow('detect', detect_results[0].plot())

        pose_results = pose_model(frame)
        keypoints = pose_results[0].keypoints.xyn.tolist()
        if keypoints[0]:
            frames.put(sum(keypoints[0], []))
        else:
            frames.put([0.0] * 34)

        if frames.full():
            data = torch.tensor(list(frames.queue))
            action_result = action_model(data)
            action_result = ['normal', 'fight', 'falldown'][torch.argmax(action_result)]

            image = pose_results[0].plot()
            cv2.putText(image, f'action_result: {action_result}', (50, 50), cv2.FONT_HERSHEY_PLAIN, 1, (0, 0, 0), 2)
            cv2.imshow('pose', image)
            frames.get()

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cv2.destroyAllWindows()
