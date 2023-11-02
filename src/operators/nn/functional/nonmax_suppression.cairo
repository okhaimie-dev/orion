use option::OptionTrait;

use orion::operators::tensor::math::{exp::exp_upcast, arithmetic::div_downcast};
use orion::numbers::{FP16x16, NumberTrait};
use orion::numbers::fixed_point::core::FixedTrait;
use orion::operators::tensor::core::{Tensor, TensorTrait};

// fn iou() -> FP64 {}

fn sort_indices() {}

/// Cf: NNTrait::relu docstring
fn nonmax_suppression<
    T,
    MAG,
    impl TTensor: TensorTrait<T>,
    impl TPartialOrd: PartialOrd<T>,
    impl TNumber: NumberTrait<T, MAG>,
    impl TCopy: Copy<T>,
    impl TDrop: Drop<T>
>(
    mut b: Tensor<T>,
    mut s: @Tensor<T>,
    mut max: Option<Tensor<T>>,
    mut iou: Option<Tensor<T>>,
    mut score_threshold: Option<Tensor<T>>,
    mut center: @T
) -> Tensor<T> {
    let mut scores = ArrayTrait::<T>::new();
    
    let mut selected_indices = ArrayTrait::<T>::new();

    loop {

    };

    return TensorTrait::new(b, iou);
}

fn calculate_iou() -> FP16x16 {
    let xA = f64::max(box1.x1, box2.x1);
    let yA = f64::max(box1.y1, box2.y1);
    let xB = f64::min(box1.x2, box2.x2);
    let yB = f64::min(box1.y2, box2.y2);
    
    let intersection = FP16x16::max(0.0, xB - xA) * FP16x16::max(0.0, yB - yA);
    let area1 = (box1.x2 - box1.x1) * (box1.y2 - box1.y1);
    let area2 = (box2.x2 - box2.x1) * (box2.y2 - box2.y1);
    let union = area1 + area2 - intersection;

    intersection / union
}
