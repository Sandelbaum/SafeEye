import cv2
from ultralytics import YOLO


def train():
    model = YOLO('yolov8n.pt')
    result = model.train(data='data.yaml', epochs=100, imgsz=640, device='mps')
    print(result)


def real_time_video():
    # detect_model = YOLO('yolov8n.pt')
    pose_model = YOLO('yolov8s-pose.pt')

    cap = cv2.VideoCapture(0)

    while cap.isOpened():
        ret, frame = cap.read()
        if ret:
            pose_results = pose_model.predict(frame, conf=0.5, device='cpu')
            print(pose_results[0])
            cv2.imshow('pose', pose_results[0].plot())

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cv2.destroyAllWindows()


def single_image():
    pose_model = YOLO('yolov8l-pose.pt')

    for i in range(1, 8):
        image = cv2.imread(f'images/test{i}.jpeg')
        pose_result = pose_model.predict(image, conf=0.5, device='cpu')
        cv2.imshow('pose', pose_result[0].plot())
        cv2.waitKey()


if __name__ == '__main__':
    real_time_video()
    # single_image()
