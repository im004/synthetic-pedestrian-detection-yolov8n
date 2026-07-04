# Results

This folder contains the reconstructed final metric table from the project report.

## Final validation metrics

All five conditions were evaluated on the same fixed real validation split of 441 images and 2,705 filtered pedestrian instances.

| Condition | Precision | Recall | mAP50 | mAP50-95 |
|---|---:|---:|---:|---:|
| C1: Real-only | 0.693 | 0.513 | 0.591 | 0.375 |
| C2: Synthetic-only | 0.227 | 0.241 | 0.220 | 0.106 |
| C3: 50/50 mix | 0.745 | 0.549 | 0.652 | 0.420 |
| C4: 70:30 mix | 0.740 | 0.563 | 0.666 | 0.429 |
| C5: Synthetic pretrain + real fine-tune | 0.751 | 0.558 | 0.659 | 0.423 |

The full YOLO `results.csv` files are not included because the original run directories were not available at repository creation time. This folder records the final validated values used in the dissertation and portfolio summary.
