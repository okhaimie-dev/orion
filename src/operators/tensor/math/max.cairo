use core::array::{ArrayTrait, SpanTrait};

use orion::numbers::NumberTrait;
use orion::operators::tensor::core::{Tensor, TensorTrait, unravel_index};
use orion::operators::tensor::helpers::{
    broadcast_shape, broadcast_index_mapping, len_from_shape, check_compatibility
};

/// Cf: TensorTrait::max docstring
fn max<
    T,
    MAG,
    impl TTensorTrait: TensorTrait<T>,
    impl TNumber: NumberTrait<T, MAG>,
    impl TCopy: Copy<T>,
    impl TDrop: Drop<T>
>(
    tensors: Span<Tensor<T>>
) -> Tensor<T> {
    assert(tensors.len() >= 1, 'Input tensors must be >= 1');

    let first_tensor = *tensors.at(0);

    if tensors.len() == 1 {
        return first_tensor;
    }

    let mut max_shape: Span<usize> = first_tensor.shape;
    let mut max_data: Span<T> = first_tensor.data;

    let mut tensor_counter: usize = 1;

    loop {
        if tensor_counter > tensors.len() - 1 {
            break;
        }

        let mut new_max_data = ArrayTrait::<T>::new();

        let mut current_tensor = *tensors.at(tensor_counter);

        let mut broadcasted_shape = broadcast_shape(max_shape, current_tensor.shape);

        let num_elements = len_from_shape(broadcasted_shape);
        let mut n: usize = 0;
        loop {
            let mut indices_broadcasted = unravel_index(n, broadcasted_shape);

            let mut indices_self = broadcast_index_mapping(max_shape, indices_broadcasted);
            let mut indices_other = broadcast_index_mapping(
                current_tensor.shape, indices_broadcasted
            );

            let mut max_value = NumberTrait::max(
                *(max_data)[indices_self], *(current_tensor.data)[indices_other]
            );
            new_max_data.append(max_value);

            n += 1;
            if n == num_elements {
                break ();
            };
        };

        max_shape = broadcasted_shape;
        max_data = new_max_data.span();
        tensor_counter += 1;
    };

    return TensorTrait::<T>::new(max_shape, max_data);
}
