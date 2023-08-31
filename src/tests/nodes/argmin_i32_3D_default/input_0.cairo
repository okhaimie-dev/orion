use array::ArrayTrait;
use orion::operators::tensor::core::{TensorTrait, Tensor, ExtraParams};
use orion::numbers::fixed_point::core::FixedImpl;
use orion::operators::tensor::implementations::tensor_i32_fp16x16::Tensor_i32_fp16x16;
use orion::numbers::{i32, FP16x16};

fn input_0() -> Tensor<i32> {
    let mut shape = ArrayTrait::<usize>::new();
    shape.append(2);
    shape.append(2);
    shape.append(2);

    let mut data = ArrayTrait::new();
    data.append(i32 { mag: 56, sign: false });
    data.append(i32 { mag: 40, sign: true });
    data.append(i32 { mag: 32, sign: true });
    data.append(i32 { mag: 42, sign: true });
    data.append(i32 { mag: 64, sign: false });
    data.append(i32 { mag: 95, sign: true });
    data.append(i32 { mag: 117, sign: true });
    data.append(i32 { mag: 4, sign: false });

    let extra = ExtraParams { fixed_point: Option::Some(FixedImpl::FP16x16) };
    TensorTrait::new(shape.span(), data.span(), Option::Some(extra))
}