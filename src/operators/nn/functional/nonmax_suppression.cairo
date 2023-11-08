use option::OptionTrait;
use box::{Box, BoxTrait};
use array::{ArrayTrait, SpanTrait};

use orion::numbers::fixed_point::core::FixedTrait;
use orion::operators::tensor::core::{Tensor, TensorTrait};
use orion::numbers::NumberTrait;

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

    returnTensorTrait::new();
}


//```rust 
// fn non_max_suppression(
//     boxes: &mut [Box],
//     scores: &mut [f64],
//     max_output_boxes_per_class: usize,
//     iou_threshold: f64,
//     score_threshold: f64
// ) -> Vec<usize> {
//     let mut indices: Vec<usize> = (0..boxes.len()).collect();
//     indices.sort_by(|&i, &j| scores[j].partial_cmp(&scores[i]).unwrap());
//
//     let mut selected_indices = Vec::new();
//     while indices.len() > 0 && selected_indices.len() < max_output_boxes_per_class {
//         let current = indices[0];
//         selected_indices.push(current);
//
//         let remaining: Vec<usize> = indices.iter().skip(1)
//             .filter(|&&i| {
//                 let iou = calculate_iou(&boxes[current], &boxes[i]);
//                 iou < iou_threshold
//             })
//             .cloned()
//             .collect();
//
//         indices = remaining;
//     }
//
//     selected_indices
// }
// ```
//
//```rust
// fn calculate_iou(
//     box1: &Box,
//     box2: &Box
// ) -> f64 {
//     let x_a = max(box1.x1, box2.x1);
//     let y_a = max(box1.y1, box2.y1);
//     let x_b = min(box1.x2, box2.x2);
//     let y_b = min(box1.y2, box2.y2);
//
//     let intersection_area = max(0, x_b - x_a + 1) * max(0, y_b - y_a + 1);
//
//     let box1_area = (box1.x2 - box1.x1 + 1) * (box1.y2 - box1.y1 + 1);
//     let box2_area = (box2.x2 - box2.x1 + 1) * (box2.y2 - box2.y1 + 1);
//
//     intersection_area as f64 / (box1_area + box2_area - intersection_area) as f64
// }
//```

