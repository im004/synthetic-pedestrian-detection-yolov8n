# Push instructions

The GitHub connector returned a 403 write error, so this folder is prepared as a complete local repository scaffold.

To push it yourself:

```bash
cd synthetic-pedestrian-detection-yolov8n
git init
git branch -M main
git add .
git commit -m "Initial FYP research repository"
git remote add origin git@github.com:im004/synthetic-pedestrian-detection-yolov8n.git
git push -u origin main
```

If the remote already has files, use:

```bash
git pull origin main --allow-unrelated-histories
git push -u origin main
```

Recommended GitHub repo settings:

- Description: `Final year project evaluating synthetic-to-real pedestrian detection transfer using YOLOv8n across five controlled training strategies.`
- Topics: `yolov8`, `computer-vision`, `object-detection`, `synthetic-data`, `pedestrian-detection`, `pytorch`, `ultralytics`, `autonomous-driving`
```
