use core::option::OptionTrait;

use orion::operators::tensor::core::Tensor;
use orion::operators::nn::core::NNTrait;
use orion::operators::nn::functional;
use orion::numbers::fixed_point::implementations::fp32x32::core::{FP32x32, FP32x32Impl};
use orion::operators::tensor::implementations::tensor_fp32x32::{
    FP32x32Tensor, FP32x32TensorDiv, FP32x32TensorAdd
};

impl FP32x32NN of NNTrait<FP32x32> {
    fn relu(tensor: @Tensor<FP32x32>) -> Tensor<FP32x32> {
        functional::relu::relu(*tensor)
    }

    fn sigmoid(tensor: @Tensor<FP32x32>) -> Tensor<FP32x32> {
        functional::sigmoid::sigmoid(*tensor)
    }

    fn softmax(tensor: @Tensor<FP32x32>, axis: usize) -> Tensor<FP32x32> {
        functional::softmax::softmax(tensor, axis)
    }

    fn logsoftmax(tensor: @Tensor<FP32x32>, axis: usize) -> Tensor<FP32x32> {
        functional::logsoftmax::logsoftmax(tensor, axis)
    }

    fn softsign(tensor: @Tensor<FP32x32>) -> Tensor<FP32x32> {
        functional::softsign::softsign(*tensor)
    }

    fn softplus(tensor: @Tensor<FP32x32>) -> Tensor<FP32x32> {
        functional::softplus::softplus(*tensor)
    }

    fn linear(
        inputs: Tensor<FP32x32>, weights: Tensor<FP32x32>, bias: Tensor<FP32x32>
    ) -> Tensor<FP32x32> {
        functional::linear::linear(inputs, weights, bias)
    }

    fn leaky_relu(inputs: @Tensor<FP32x32>, alpha: @FP32x32) -> Tensor<FP32x32> {
        functional::leaky_relu::leaky_relu(*inputs, alpha)
    }

    fn thresholded_relu(tensor: @Tensor<FP32x32>, alpha: @FP32x32) -> Tensor<FP32x32> {
        functional::thresholded_relu::thresholded_relu(*tensor, alpha)
    }

    fn hard_sigmoid(tensor: @Tensor<FP32x32>, alpha: @FP32x32, beta: @FP32x32) -> Tensor<FP32x32> {
        functional::hard_sigmoid::hard_sigmoid(*tensor, alpha, beta)
    }

    fn gemm(
        A: Tensor<FP32x32>,
        B: Tensor<FP32x32>,
        C: Option<Tensor<FP32x32>>,
        alpha: Option<FP32x32>,
        beta: Option<FP32x32>,
        transA: bool,
        transB: bool
    ) -> Tensor<FP32x32> {
        functional::gemm::gemm(A, B, C, alpha, beta, transA, transB)
    }

    fn nonmax_suppression(
        boxes: @Tensor<FP32x32>, 
        scores: @Tensor<FP32x32>, 
        max_output_boxes_per_class: Option<Tensor<FP32x32>>,
        iou_threshold: Option<Tensor<FP32x32>>,
        score_threshold: Option<Tensor<FP32x32>>,
        center_point_box: usize
    ) -> Tensor<FP32x32> {
        functional::nonmax_suppression::nonmax_suppression(boxes, scores, max_output_boxes_per_class, iou_threshold, score_threshold, center_point_box)
    }
}
