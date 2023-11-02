use core::option::OptionTrait;

use orion::operators::tensor::core::Tensor;
use orion::operators::nn::core::NNTrait;
use orion::operators::nn::functional;
use orion::numbers::fixed_point::implementations::fp8x23::core::FP8x23;
use orion::operators::tensor::implementations::tensor_fp8x23::{
    FP8x23Tensor, FP8x23TensorDiv, FP8x23TensorAdd
};
use orion::numbers::fixed_point::implementations::fp8x23wide::core::{
    FP8x23WImpl, FP8x23WTryIntoFP8x23, FP8x23W, FP8x23IntoFP8x23W
};
use orion::operators::tensor::implementations::tensor_fp8x23wide::{FP8x23WTensor};

impl FP8x23NN of NNTrait<FP8x23> {
    fn relu(tensor: @Tensor<FP8x23>) -> Tensor<FP8x23> {
        functional::relu::relu(*tensor)
    }

    fn sigmoid(tensor: @Tensor<FP8x23>) -> Tensor<FP8x23> {
        functional::sigmoid::sigmoid(*tensor)
    }

    fn softmax(tensor: @Tensor<FP8x23>, axis: usize) -> Tensor<FP8x23> {
        functional::softmax::softmaxWide::<FP8x23, u32, FP8x23W, u64>(tensor, axis)
    }

    fn logsoftmax(tensor: @Tensor<FP8x23>, axis: usize) -> Tensor<FP8x23> {
        functional::logsoftmax::logsoftmaxWide::<FP8x23, u32, FP8x23W, u64>(tensor, axis)
    }

    fn softsign(tensor: @Tensor<FP8x23>) -> Tensor<FP8x23> {
        functional::softsign::softsign(*tensor)
    }

    fn softplus(tensor: @Tensor<FP8x23>) -> Tensor<FP8x23> {
        functional::softplus::softplus(*tensor)
    }

    fn linear(
        inputs: Tensor<FP8x23>, weights: Tensor<FP8x23>, bias: Tensor<FP8x23>
    ) -> Tensor<FP8x23> {
        functional::linear::linear(inputs, weights, bias)
    }

    fn leaky_relu(inputs: @Tensor<FP8x23>, alpha: @FP8x23) -> Tensor<FP8x23> {
        functional::leaky_relu::leaky_relu(*inputs, alpha)
    }

    fn thresholded_relu(tensor: @Tensor<FP8x23>, alpha: @FP8x23) -> Tensor<FP8x23> {
        functional::thresholded_relu::thresholded_relu(*tensor, alpha)
    }

    fn hard_sigmoid(tensor: @Tensor<FP8x23>, alpha: @FP8x23, beta: @FP8x23) -> Tensor<FP8x23> {
        functional::hard_sigmoid::hard_sigmoid(*tensor, alpha, beta)
    }

    fn gemm(
        A: Tensor<FP8x23>,
        B: Tensor<FP8x23>,
        C: Option<Tensor<FP8x23>>,
        alpha: Option<FP8x23>,
        beta: Option<FP8x23>,
        transA: bool,
        transB: bool
    ) -> Tensor<FP8x23> {
        functional::gemm::gemm(A, B, C, alpha, beta, transA, transB)
    }

    fn nonmax_suppression(
        boxes: @Tensor<FP8x23>, 
        scores: @Tensor<FP8x23>, 
        max_output_boxes_per_class: Option<Tensor<FP8x23>>,
        iou_threshold: Option<Tensor<FP8x23>>,
        score_threshold: Option<Tensor<FP8x23>>,
        center_point_box: usize
    ) -> Tensor<FP8x23> {
        functional::nonmax_suppression::nonmax_suppression(b, s, max, iou, score_threshold, center)
    }
}
