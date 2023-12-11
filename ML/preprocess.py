import os
import cv2
import utils

from typing import Optional


DATA_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'data')


class Preprocess:
    def __init__(self):
        pass


    def run(self):
        # self.group()

        # self.extract('normal')
        # self.extract('fight')
        # self.extract('falldown')

        self.label('normal')
        self.label('fight')
        self.label('falldown')


    def group(self):
        import shutil
        count = 0
        size = 0
        src = os.path.join(DATA_PATH, 'extract', 'normal2', '0000')
        dst = os.path.join(DATA_PATH, 'extract', 'normal', f'{count:04d}')
        utils.ensure_path(dst)
        for file in os.listdir(src):
            shutil.copyfile(os.path.join(src, file), os.path.join(dst, f'{size:04d}.png'))

            if size >= 59:
                size = 0
                count += 1
                dst = os.path.join(DATA_PATH, 'extract', 'normal', f'{count:04d}')
                utils.ensure_path(dst)
                continue
            size += 1


    def extract(self, name: str, extract_count: Optional[int] = None) -> None:
        named_path = os.path.join(DATA_PATH, name)

        if not extract_count:
            min_length = self._min_length_of_30fps(named_path)
        else:
            min_length = extract_count

        for i, filename in enumerate(os.listdir(named_path)):
            file_path = os.path.join(named_path, filename)

            cap = cv2.VideoCapture(file_path)
            video_length = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
            video_fps = float(cap.get(cv2.CAP_PROP_FPS))
            video_width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
            video_height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

            print('=== Extract Images from Video ===')
            print('Total frame count :', video_length)
            print('Frame rate :', video_fps)
            print('Size :', video_width, 'x', video_height)

            video_width = 1280
            video_height = 720

            scale = f'(iw*sar)*min({video_width}/(iw*sar)\,{video_height}/ih):ih*min({video_width}/(iw*sar)\,{video_height}/ih)'
            padding = f'{video_width}:{video_height}:({video_width}-iw*min({video_width}/iw\,{video_height}/ih))/2:({video_height}-ih*min({video_width}/iw\,{video_height}/ih))/2'
            fps = float((min_length - 2) / (video_length / video_fps)) or 1.0

            individual_extract_path = os.path.join(DATA_PATH, 'extract', name, f'{i:04d}')

            utils.ensure_path(individual_extract_path)

            utils.run_system(
                f'ffmpeg '
                f'-i {file_path} '
                f'-vf "scale={scale}, pad={padding}" '
                f'-r {fps} {individual_extract_path}/%04d.png'
            )


    def label(self, name):
        from ultralytics import YOLO

        print('load yolo model...')
        model = YOLO('yolov8x-pose.pt')
        model.to(0)

        named_path = os.path.join(DATA_PATH, 'extract', name)

        for dirname in os.listdir(named_path):
            # for filename in os.listdir(os.path.join(named_path, dirname)):
            results = model(os.path.join(named_path, dirname), stream=True)
            file_path = os.path.join(named_path, dirname, 'keypoints.txt')

            with open(file_path, 'w+') as file:
                for result in results:
                    keypoints = result.keypoints.xyn.tolist()
                    if len(keypoints) < 1:
                        file.write(f'{[0.0] * 34}')
                        continue
                    file.write(f'{sum(keypoints[0], [])}\n')

            print(file_path)


    def _min_length_of_30fps(self, path: str) -> None:
        min_length = self._fetch_min_length(path)
        return min_length - (min_length % 30)


    def _fetch_min_length(self, path: str) -> None:
        import sys
        result = sys.maxsize

        for filename in os.listdir(path):
            file_path = os.path.join(path, filename)
            cap = cv2.VideoCapture(file_path)
            video_length = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
            result = min(result, video_length)

        return result


Preprocess().run()