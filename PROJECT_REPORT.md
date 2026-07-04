# Project Report Summary

## Title

**Synthetic pedestrian detection dataset for autonomous vehicles**

## Research question

How effective is synthetic pedestrian data for improving the real-world performance of deep learning pedestrian detection models compared with real-world data alone, and does the integration strategy matter?

## Aim

To determine whether synthetic pedestrian imagery improves real-world YOLOv8n pedestrian detection performance, and to identify the most effective integration strategy under realistic compute constraints.

## Background

Pedestrian detection is a safety-critical perception task in autonomous driving and driver-assistance systems. Real-world datasets are limited by collection cost, annotation effort, privacy concerns, and poor coverage of rare but important scenarios such as occlusion, unusual poses, low-light conditions, and dense urban interactions.

Synthetic data provides automatically labelled, controllable training imagery. However, models trained only on synthetic data often fail when evaluated on real images because of the synthetic-to-real domain gap: differences in texture, lighting, camera geometry, background statistics, and occlusion complexity.

## Methodology

The project used YOLOv8n as the detector architecture and tested five controlled experimental conditions.

| Condition | Description |
|---|---|
| C1 | Real-only baseline |
| C2 | Synthetic-only training evaluated on real validation data |
| C3 | 50/50 real + synthetic mixed training |
| C4 | 70:30 real-dominated mixed training |
| C5 | Synthetic pretraining followed by real fine-tuning |

All conditions used the same YOLOv8n architecture, 640x640 input resolution, batch size of 4, consistent augmentation settings, and a fixed real validation split. Conditions 1-4 used 50 training epochs. Condition 5 used a 50 + 50 epoch two-stage transfer process.

## Datasets

- **Real data:** CityPersons / Cityscapes-derived YOLO pedestrian dataset.
- **Synthetic data:** SYNTHIA-PANO and CARLA-derived pedestrian imagery.
- **Validation:** fixed real validation set of 441 images and 2,705 filtered pedestrian instances.

The synthetic datasets are not redistributed in this repository. Users should obtain the datasets from their original sources and convert them into the expected YOLO directory structure.

## Final results

| Condition | Precision | Recall | mAP50 | mAP50-95 | Finding |
|---|---:|---:|---:|---:|---|
| C1: Real-only | 0.693 | 0.513 | 0.591 | 0.375 | Baseline |
| C2: Synthetic-only | 0.227 | 0.241 | 0.220 | 0.106 | Severe domain gap |
| C3: 50/50 mix | 0.745 | 0.549 | 0.652 | 0.420 | Improved over baseline |
| C4: 70:30 mix | 0.740 | 0.563 | 0.666 | 0.429 | Best overall mAP and recall |
| C5: Pretrain + fine-tune | 0.751 | 0.558 | 0.659 | 0.423 | Highest precision |

## Main findings

1. **Synthetic-only training did not transfer well to real imagery.** C2 achieved mAP50 = 0.220, a 62.8% relative drop from the real-only baseline.

2. **Synthetic data improved performance when combined with real data.** C3, C4, and C5 all exceeded the real-only baseline across the main metrics.

3. **Integration strategy mattered.** The 70:30 real-dominated mix achieved the strongest overall result, suggesting that synthetic data works best as a controlled augmentation to real-domain signal rather than as an equal or exclusive replacement.

4. **Sequential pretraining produced a different operating profile.** C5 achieved the highest precision, likely because synthetic pretraining exposed the model to clean bounding-box supervision before real fine-tuning.

## Engineering relevance

The work demonstrates an end-to-end ML experimentation workflow: dataset preparation, annotation filtering, controlled training conditions, command-line reproducibility, evaluation metrics, and critical analysis of model behaviour.

## Limitations

- Dataset scale is limited compared with industrial pedestrian detection datasets.
- Trained weights are not included due to file-size constraints.
- The validation split is internal rather than a completely separate benchmark.
- CPU-only training constrained batch size and model scale.
- No deployment claim is made; the project is comparative research evidence only.

## Future work

- Evaluate on external datasets such as EuroCity Persons or INRIA Person.
- Repeat random synthetic sampling to quantify variance.
- Test larger YOLOv8 variants with GPU acceleration.
- Explore style transfer or domain adaptation to reduce synthetic-to-real texture gap.
- Deploy the best model on edge hardware such as Jetson Nano or Raspberry Pi 5 for feasibility testing.
