use alexandria_data_structures::array_ext::SpanTraitExt;
use core::array::SpanTrait;

use orion::numbers::NumberTrait;
use orion::operators::tensor::{core::{Tensor, TensorTrait}, math::arithmetic::mul_by_scalar};

/// Cf: NNTrait::gemm docstring
fn gemm<
    T,
    MAG,
    impl TTensor: TensorTrait<T>,
    impl TAddTensor: Add<Tensor<T>>,
    impl TNumberTrait: NumberTrait<T, MAG>,
    impl TPartialEq: PartialEq<T>,
    impl TMul: Mul<T>,
    impl TCopy: Copy<T>,
    impl TDrop: Drop<T>
>(
    A: Tensor<T>,
    B: Tensor<T>,
    C: Option<Tensor<T>>,
    alpha: Option<T>,
    beta: Option<T>,
    transA: bool,
    transB: bool
) -> Tensor<T> {
    let mut A = A;
    let mut B = B;

    let alpha: T = if alpha.is_some() {
        alpha.unwrap()
    } else {
        NumberTrait::one()
    };

    let beta: T = if beta.is_some() {
        beta.unwrap()
    } else {
        NumberTrait::one()
    };

    if transA == true {
        A = A.transpose(array![1, 0].span());
    }

    if transB == true {
        B = B.transpose(array![1, 0].span());
    }

    match C {
        Option::Some(c) => {
            let broadcast_c_shape = if c.shape.len() == 1 {
                array![1].span().concat(c.shape)
            } else {
                c.shape
            };

            let c = Tensor { shape: broadcast_c_shape, data: c.data };

            return mul_by_scalar(@A.matmul(@B), alpha) + mul_by_scalar(@c, beta);
        },
        Option::None => { return mul_by_scalar(@A.matmul(@B), alpha); }
    }
}
