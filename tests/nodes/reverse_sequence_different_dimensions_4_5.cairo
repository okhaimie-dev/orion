mod input_0;
mod output_0;


use orion::operators::tensor::{U32Tensor, U32TensorAdd};
use core::array::{ArrayTrait, SpanTrait};
use orion::operators::tensor::U32TensorPartialEq;
use orion::utils::{assert_eq, assert_seq_eq};
use orion::operators::tensor::{TensorTrait, Tensor};

#[test]
#[available_gas(2000000000)]
fn test_reverse_sequence_different_dimensions_4_5() {
    let input_0 = input_0::input_0();
    let z_0 = output_0::output_0();

    let y_0 = input_0.reverse_sequence(TensorTrait::<usize>::new(array![4].span(), array![5,4,3,2].span()), Option::Some(0), Option::Some(1));

    assert_eq(y_0, z_0);
}
