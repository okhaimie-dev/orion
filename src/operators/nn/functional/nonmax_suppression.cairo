use option::OptionTrait;
use box::{Box, BoxTrait};
use array::{ArrayTrait, SpanTrait};

use orion::numbers::fixed_point::core::FixedTrait;
use orion::operators::tensor::core::{Tensor, TensorTrait};
use orion::numbers::{FP8x23, FixedTrait};

#[derive(Copy, Drop)]
struct BoundingBox {
    x1: FP8x23,
    y1: FP8x23,
    x2: FP8x23,
    y2: FP8x23,
}

fn calculate_iou(box1: @BoundingBox, box2: @BoundingBox) -> FP8x23 {
    let xA = FP8x23::max(box1.x1, box2.x1);
    let yA = FP8x23::max(box1.y1, box2.y1);
    let xB = FP8x23::min(box1.x2, box2.x2);
    let yB = FP8x23::min(box1.y2, box2.y2);

    let intersection_area = FP8x23::max(0, xB - xA) * FP8x23::max(0, yB - yA);
    let area1 = (box1.x2 - box1.x1) * (box1.y2 - box1.y1);
    let area2 = (box2.x2 - box2.x1) * (box2.y2 - box2.y1);
    let union = area1 + area2 - intersection_area;

    return intersection_area / union;
}

/// Cf: NNTrait::relu docstring
fn nonmax_suppression<
    T,
    MAG,
    impl TTensor: TensorTrait<T>,
    impl TNumber: NumberTrait<T, MAG>,
    impl TCopy: Copy<T>,
    impl TDrop: Drop<T>
>(
    boxes: @Tensor<T>, 
    scores: @Tensor<T>, 
    max_output_boxes_per_class: Option<Tensor<T>>,
    iou_threshold: Option<Tensor<T>>,
    score_threshold: Option<Tensor<T>>,
    center_point_box: usize
) -> Tensor<T> {
    let mut boxes = ArrayTrait::<T>::new();
    let mut selected_indices = ArrayTrait::<T>::new();

    loop {

    };

    return selected_indices;
}


//```rust 
// fn non_max_suppression(boxes: &Vec<BoundingBox>, scores: &Vec<f64>, threshold: f64) -> Vec<usize> {
    // let mut indices: Vec<usize> = (0..scores.len()).collect();
    // indices.sort_by(|&a, &b| scores[b].partial_cmp(&scores[a]).unwrap());

    // let mut selected_indices = vec![];

    // while !indices.is_empty() {
    //     let current_index = indices[0];
    //     selected_indices.push(current_index);

    //     let mut to_remove = vec![];

    //     for (i, &index) in indices.iter().enumerate() {
    //         if i == 0 {
    //             continue;
    //         }

    //         let iou = calculate_iou(&boxes[current_index], &boxes[index]);

    //         if iou > threshold {
    //             to_remove.push(i);
    //         }
    //     }

    //     for &i in to_remove.iter().rev() {
    //         indices.remove(i);
    //     }
    // }

    // selected_indices
// }
// ```
