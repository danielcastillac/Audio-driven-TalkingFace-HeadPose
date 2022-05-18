import subprocess

subprocess.call(['python', 'extract_frame1.py', '31.mp4'], cwd = "./Data")
subprocess.call(['python', 'demo_19news.py', '../Data/31'], cwd = "./Deep3DFaceReconstruction")
subprocess.call(['python', 'train_19news_1.py', '31', '0'], cwd = "./Audio/code")
subprocess.call(['python', 'train_19news_1.py', '31', '0'], cwd = "./render-to-video")