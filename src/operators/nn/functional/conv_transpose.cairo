use orion::numbers::NumberTrait;
use orion::operators::tensor::{TensorTrait, Tensor, U32Tensor,};
use orion::operators::vec::{NullableVec, NullableVecImpl};
use orion::operators::tensor::core::{stride};

#[derive(Copy, Drop)]
enum AUTO_PAD {
    NOTSET,
    SAME_UPPER,
    SAME_LOWER,
    VALID
}

fn conv_transpose<
    T, MAG, +TensorTrait<T>, +NumberTrait<T, MAG>, +Copy<T>, +Drop<T>, +Add<T>, +Mul<T>,
>(
    X: @Tensor<T>,
    W: @Tensor<T>,
    B: Option<@Tensor<T>>,
    auto_pad: Option<AUTO_PAD>,
    dilations: Option<Span<usize>>,
    group: Option<usize>,
    kernel_shape: Option<Span<usize>>,
    output_padding: Option<Span<usize>>,
    output_shape: Option<Span<usize>>,
    pads: Option<Span<usize>>,
    strides: Option<Span<usize>>,
) -> Tensor<T> {
    let auto_pad = match auto_pad {
        Option::Some(auto_pad) => auto_pad,
        Option::None => { AUTO_PAD::NOTSET },
    };
    let dilations = match dilations {
        Option::Some(dilations) => dilations,
        Option::None => {
            let mut dilations = ArrayTrait::new();
            let mut i = 2;
            loop {
                if i >= (*X).shape.len() {
                    break;
                }
                dilations.append(1);
                i += 1;
            };
            dilations.span()
        },
    };
    let kernel_shape = match kernel_shape {
        Option::Some(kernel_shape) => kernel_shape,
        Option::None => {
            let mut kernel_shape = ArrayTrait::new();
            let mut i = 2;
            loop {
                if i >= (*W).shape.len() {
                    break;
                }
                kernel_shape.append(*(*W).shape.at(i));
                i += 1;
            };
            kernel_shape.span()
        },
    };
    let output_padding = match output_padding {
        Option::Some(output_padding) => output_padding,
        Option::None => {
            let mut output_padding = ArrayTrait::new();
            let mut i = 2;
            loop {
                if i >= (*X).shape.len() {
                    break;
                }
                output_padding.append(0);
                output_padding.append(0);
                i += 1;
            };
            output_padding.span()
        },
    };
    let strides = match strides {
        Option::Some(strides) => strides,
        Option::None => {
            let mut strides = ArrayTrait::new();
            let mut i = 2;
            loop {
                if i >= (*X).shape.len() {
                    break;
                }
                strides.append(1);
                i += 1;
            };
            strides.span()
        },
    };
    let (pads, _, output_shape) = match pads {
        Option::Some(pads) => {
            let n_dims = (*X).shape.len() - 2;

            let output_shape = match output_shape {
                Option::Some(output_shape) => output_shape,
                Option::None => {
                    let mut output_shape = ArrayTrait::new();
                    let mut i = 0;
                    loop {
                        if i == n_dims {
                            break;
                        }
                        output_shape
                            .append(
                                (*(*X).shape.at(i + 2) - 1) * *strides.at(i)
                                    + *output_padding.at(i)
                                    + ((*kernel_shape.at(i) - 1) * *dilations.at(i) + 1)
                                    - (*pads.at(i) + *pads.at(i + n_dims))
                            );
                        i += 1;
                    };
                    output_shape.span()
                },
            };
            (pads, n_dims, output_shape)
        },
        Option::None => {
            let (pads, n_dims, output_shape) = match auto_pad {
                AUTO_PAD::NOTSET => {
                    let mut pads = ArrayTrait::new();
                    let mut i = 0;
                    loop {
                        if i == strides.len() * 2 {
                            break;
                        }
                        pads.append(0);
                        i += 1;
                    };
                    let pads = pads.span();

                    let n_dims = (*X).shape.len() - 2;

                    let output_shape = match output_shape {
                        Option::Some(output_shape) => output_shape,
                        Option::None => {
                            let mut output_shape = ArrayTrait::new();
                            let mut i = 0;
                            loop {
                                if i == n_dims {
                                    break;
                                }

                                output_shape
                                    .append(
                                        (*(*X).shape.at(i + 2) - 1) * *strides.at(i)
                                            + *output_padding.at(i)
                                            + ((*kernel_shape.at(i) - 1) * *dilations.at(i) + 1)
                                            - (*pads.at(i) + *pads.at(i + n_dims))
                                    );
                                i += 1;
                            };
                            output_shape.span()
                        },
                    };

                    (pads, n_dims, output_shape)
                },
                AUTO_PAD::SAME_UPPER => {
                    let output_shape = match output_shape {
                        Option::Some(output_shape) => output_shape,
                        Option::None => {
                            let mut output_shape = ArrayTrait::new();
                            let mut i = 0;
                            loop {
                                if i == strides.len() {
                                    break;
                                }
                                output_shape.append(*(*X).shape.at(i + 2) * *strides.at(i));
                                i += 1;
                            };
                            output_shape.span()
                        },
                    };
                    let mut total_padding = ArrayTrait::new();

                    let mut i = 0;
                    loop {
                        if i == output_shape.len() {
                            break;
                        }
                        total_padding
                            .append(
                                (*(*X).shape.at(i + 2) - 1) * *strides.at(i)
                                    + *output_padding.at(i)
                                    + ((*kernel_shape.at(i) - 1) * *dilations.at(i) + 1)
                                    - *output_shape.at(i)
                            );
                        i += 1;
                    };
                    let total_padding = total_padding.span();

                    let mut pads = ArrayTrait::new();

                    let mut i = 0;
                    loop {
                        if i == output_shape.len() {
                            break;
                        }
                        pads.append(*total_padding.at(i) / 2);
                        i += 1;
                    };
                    let mut i = 0;
                    loop {
                        if i == output_shape.len() {
                            break;
                        }
                        pads.append(*total_padding.at(i) - (*total_padding.at(i) / 2));
                        i += 1;
                    };
                    (pads.span(), pads.len() / 2, output_shape)
                },
                AUTO_PAD::SAME_LOWER => {
                    let output_shape = match output_shape {
                        Option::Some(output_shape) => output_shape,
                        Option::None => {
                            let mut output_shape = ArrayTrait::new();
                            let mut i = 0;
                            loop {
                                if i == strides.len() {
                                    break;
                                }
                                output_shape.append(*(*X).shape.at(i + 2) * *strides.at(i));
                                i += 1;
                            };
                            output_shape.span()
                        },
                    };
                    let mut total_padding = ArrayTrait::new();

                    let mut i = 0;
                    loop {
                        if i == output_shape.len() {
                            break;
                        }
                        total_padding
                            .append(
                                (*(*X).shape.at(i + 2) - 1) * *strides.at(i)
                                    + *output_padding.at(i)
                                    + ((*kernel_shape.at(i) - 1) * *dilations.at(i) + 1)
                                    - *output_shape.at(i)
                            );
                        i += 1;
                    };
                    let total_padding = total_padding.span();

                    let mut pads = ArrayTrait::new();

                    let mut i = 0;
                    loop {
                        if i == output_shape.len() {
                            break;
                        }
                        pads.append(*total_padding.at(i) - *total_padding.at(i) / 2);
                        i += 1;
                    };
                    let mut i = 0;
                    loop {
                        if i == output_shape.len() {
                            break;
                        }
                        pads.append(*total_padding.at(i) / 2);
                        i += 1;
                    };
                    (pads.span(), pads.len() / 2, output_shape)
                },
                AUTO_PAD::VALID => {
                    let mut pads = ArrayTrait::new();
                    let mut i = 0;
                    loop {
                        if i == strides.len() * 2 {
                            break;
                        }
                        pads.append(0);
                        i += 1;
                    };
                    let pads = pads.span();

                    let n_dims = (*X).shape.len() - 2;
                    let output_shape = match output_shape {
                        Option::Some(output_shape) => output_shape,
                        Option::None => {
                            let mut output_shape = ArrayTrait::new();
                            let mut i = 0;
                            loop {
                                if i == n_dims {
                                    break;
                                }
                                output_shape
                                    .append(
                                        (*(*X).shape.at(i + 2) - 1) * *strides.at(i)
                                            + *output_padding.at(i)
                                            + ((*kernel_shape.at(i) - 1) * *dilations.at(i) + 1)
                                            - (*pads.at(i) + *pads.at(i + n_dims))
                                    );
                                i += 1;
                            };
                            output_shape.span()
                        },
                    };
                    (pads, n_dims, output_shape)
                },
            };
            (pads, n_dims, output_shape)
        },
    };
    let group = match group {
        Option::Some(group) => group,
        Option::None => { 1 },
    };

    let mut kernel_shape = ArrayTrait::new();
    let mut i = 2;
    loop {
        if i >= (*W).shape.len() {
            break;
        }
        kernel_shape.append(*(*W).shape.at(i));
        i += 1;
    };
    let kernel_shape = kernel_shape.span();
    let kernel_size = prod(kernel_shape, 0);

    let mut num_output_channels = *(*W).shape.at(1) * group;
    let mut kernel_dim = (num_output_channels / group) * kernel_size;

    let C = *(*X).shape.at(1);
    let m = kernel_dim;
    let n = prod((*X).shape, 2);
    let k = C / group;

    let mut final = ArrayTrait::new();

    if group == 1 {
        let mut image_id = 0;
        loop {
            if image_id == *(*X).shape.at(0) {
                break;
            }
            let w_t = TensorTrait::new(array![k, m].span(), (*W).data)
                .transpose(array![1, 0].span());

            let image = SpanTrait::slice((*X).data, image_id * k * n, k * n);
            let gemm = w_t.matmul(@TensorTrait::new(array![k, n].span(), image));

            let gemmc = gemm
                .reshape(array![num_output_channels, m / num_output_channels, n].span());
            let mut c = 0;
            loop {
                if c == num_output_channels {
                    break;
                }
                let gemmc_c = TensorTrait::new(
                    array![m / num_output_channels, n].span(),
                    SpanTrait::slice(
                        gemmc.data, (m / num_output_channels) * n * c, (m / num_output_channels) * n
                    )
                );

                let mut res = col2im_naive_implementation(
                    @gemmc_c, output_shape, kernel_shape, dilations, pads, strides
                );

                match B {
                    Option::Some(B) => {
                        let mut i = 0;
                        loop {
                            if i == res.len() {
                                break;
                            }
                            res.set(i, res.at(i) + *(*B).data.at(c));
                            i += 1;
                        };
                    },
                    Option::None => {},
                }
                c += 1;

                let mut i = 0;
                loop {
                    if i == res.len() {
                        break;
                    }
                    final.append(res.at(i));
                    i += 1;
                };
            };
            image_id += 1;
        };
    } else {
        let mut output_array = ArrayTrait::new();

        let mut i = 0;
        let mut output_size = 1;
        loop {
            if i == output_shape.len() {
                break;
            }
            output_size *= *output_shape.at(i);
            i += 1;
        };

        // Computation of conv transposition per group
        let mut group_id = 0;
        loop {
            if group_id == group {
                break;
            }
            let mut group_X = ArrayTrait::new();
            let mut group_W = ArrayTrait::new();

            let mut image_id = 0;
            loop {
                if image_id == *(*X).shape.at(0) {
                    break;
                }
                let start = image_id * n * C + (group_id * C / group) * n;
                let end = image_id * n * C + ((group_id + 1) * C / group) * n;

                let mut i = start;
                loop {
                    if i == end {
                        break;
                    }
                    group_X.append(*(*X).data.at(i));

                    i += 1;
                };
                image_id += 1;
            };

            let start = (group_id * C / group) * *(*W).shape.at(1) * kernel_size;
            let end = (group_id + 1) * C / group * *(*W).shape.at(1) * kernel_size;
            let mut i = start;
            loop {
                if i == end {
                    break;
                }
                group_W.append(*(*W).data.at(i));
                i += 1;
            };

            let mut shape_X = ArrayTrait::new();
            shape_X.append(*(*X).shape.at(0));
            shape_X.append(C / group);

            let mut i = 2;
            loop {
                if i >= (*X).shape.len() {
                    break;
                }
                shape_X.append(*(*X).shape.at(i));
                i += 1;
            };

            let mut shape_W = ArrayTrait::new();
            shape_W.append(C / group);

            let mut i = 1;
            loop {
                if i >= (*W).shape.len() {
                    break;
                }
                shape_W.append(*(*W).shape.at(i));
                i += 1;
            };

            // group_X : N x (C / group) x X.shape[2:]
            let group_X = TensorTrait::new(shape_X.span(), group_X.span());
            // group_W : (C / group) x *(*W).shape.at(1) x W.shape[2:]
            let group_W = TensorTrait::new(shape_W.span(), group_W.span());

            // group output : N x (num_output_channels / group) x output_shape
            let group_output = conv_transpose(
                @group_X,
                @group_W,
                B,
                Option::Some(auto_pad),
                Option::Some(dilations),
                Option::Some(1),
                Option::Some(kernel_shape),
                Option::Some(output_padding),
                Option::Some(output_shape),
                Option::Some(pads),
                Option::Some(strides)
            );

            output_array.append(group_output.data);

            group_id += 1;
        };
        let output_array = output_array.span();

        // Sorting result per item of the batch
        // output size : N (batch size) x num_output_channels x output_shape
        let mut image_id = 0;
        loop {
            if image_id == *(*X).shape.at(0) {
                break;
            }
            let mut group_id = 0;
            loop {
                if group_id == group {
                    break;
                }
                let group_output = *output_array.at(group_id);
                let mut i = image_id * output_size * (num_output_channels / group);

                loop {
                    if i == (image_id + 1) * output_size * (num_output_channels / group) {
                        break;
                    }
                    final.append(*group_output.at(i));
                    i += 1;
                };
                group_id += 1;
            };
            image_id += 1;
        };
    }
    let mut shape = array![*(*X).shape.at(0), num_output_channels];

    let mut i = 0;
    loop {
        if i == output_shape.len() {
            break;
        }
        shape.append(*output_shape.at(i));
        i += 1;
    };

    return TensorTrait::new(shape.span(), final.span());
}

fn get_image<T, +Drop<T>, +Copy<T>>(self: @Tensor<T>, row: usize) -> Span<T> {
    assert((*self).shape.len() == 2, 'Expected a 2D tensor');

    let row_length = *self.shape[1];
    let start = row * row_length;

    (*self).data.slice(start, row_length)
}

fn col2im_naive_implementation<
    T, MAG, +TensorTrait<T>, +NumberTrait<T, MAG>, +Copy<T>, +Drop<T>, +Add<T>,
>(
    data: @Tensor<T>,
    image_shape: Span<usize>,
    kernel_shape: Span<usize>,
    dilations: Span<usize>,
    pads: Span<usize>,
    strides: Span<usize>,
) -> NullableVec<T> {
    let n_dims = pads.len() / 2;

    col2im_shape_check(data, image_shape, kernel_shape, dilations, pads, strides);

    let mut dim_col = ArrayTrait::new();
    let mut i = 0;
    loop {
        if i == n_dims {
            break;
        }
        dim_col
            .append(
                (*image_shape.at(i)
                    + (*pads.at(i) + *pads.at(i + n_dims))
                    - (*dilations.at(i) * (*kernel_shape.at(i) - 1) + 1))
                    / *strides.at(i)
                    + 1
            );

        i += 1;
    };
    let dim_col = dim_col.span();

    let stride_img = stride(image_shape);

    let mut data_im = NullableVecImpl::new();
    data_im.set(*image_shape.at(0) * *stride_img.at(0) - 1, NumberTrait::zero());

    let kernel_size = prod(kernel_shape, 0);
    let col_size = prod(dim_col, 0);
    let mut c_col = 0;
    loop {
        if c_col == kernel_size {
            break;
        }
        let offset = get_indices(c_col, kernel_shape).span();

        let mut col = 0;
        loop {
            if col == col_size {
                break;
            }
            let ind_col = get_indices(col, dim_col).span();
            let mut ind_im = ArrayTrait::new();
            let mut i = 0;
            loop {
                if i == n_dims {
                    break;
                }
                if (*ind_col.at(i) * *strides.at(i) + *offset.at(i) * *dilations.at(i)) < *pads
                    .at(i) {
                    let neg_index = *pads.at(i)
                        - (*ind_col.at(i) * *strides.at(i) + *offset.at(i) * *dilations.at(i));
                    ind_im.append(*image_shape.at(i) + neg_index);
                } else {
                    ind_im
                        .append(
                            *ind_col.at(i) * *strides.at(i)
                                + *offset.at(i) * *dilations.at(i)
                                - *pads.at(i)
                        );
                }

                i += 1;
            };
            let ind_im = ind_im.span();
            if !is_out(ind_im, image_shape) {
                let mut index = 0;
                let mut i = 0;
                loop {
                    if i == image_shape.len() {
                        break;
                    }
                    index += *stride_img.at(i) * *ind_im.at(i);
                    i += 1;
                };
                data_im.set(index, data_im.at(index) + *(*data).data.at(c_col * col_size + col));
            }
            col += 1;
        };
        c_col += 1;
    };

    return data_im;
}

fn col2im_shape_check<T, +TensorTrait<T>, +Copy<T>, +Drop<T>,>(
    X: @Tensor<T>,
    output_shape: Span<usize>,
    kernel_shape: Span<usize>,
    dilations: Span<usize>,
    pads: Span<usize>,
    strides: Span<usize>,
) {
    let n_input_plane = *(*X).shape.at(0);

    let kernel_size = prod(kernel_shape, 0);

    assert(n_input_plane % kernel_size == 0, 'wrong input dimension');

    let input_length = *(*X).shape.at(1);
    let n_dims = output_shape.len();
    let mut n_blocks = ArrayTrait::new();

    let mut i = 0;
    loop {
        if i == n_dims {
            break;
        }
        n_blocks
            .append(
                (*output_shape.at(i)
                    + (*pads.at(i) + *pads.at(i + n_dims))
                    - *dilations.at(i) * (*kernel_shape.at(i) - 1)
                    - 1)
                    / *strides.at(i)
                    + 1
            );
        i += 1;
    };

    let block_size = prod(n_blocks.span(), 0);

    assert(input_length == block_size, 'input_length != block_size');
}


fn get_indices(index: usize, shape: Span<usize>,) -> Array<usize> {
    let mut i = index;
    let mut res = ArrayTrait::new();
    let mut k = shape.len() - 1;
    loop {
        if k == 0 {
            break;
        }
        let m = i % *shape.at(k);
        res.append(m);
        i -= m;
        i /= *shape.at(k);
        k -= 1;
    };

    let mut new_res = ArrayTrait::new();
    new_res.append(i);
    let mut i = shape.len() - 1;
    loop {
        if i == 0 {
            break;
        }
        new_res.append(*res.at(i - 1));
        i -= 1;
    };
    return new_res;
}

fn is_out(ind: Span<usize>, shape: Span<usize>,) -> bool {
    let mut n = 0;
    let is_out = loop {
        if n == ind.len() {
            break false;
        }
        let s = *shape.at(n);
        let i = *ind.at(n);
        if i < 0 {
            break true;
        }
        if i >= s {
            break true;
        }
        n += 1;
    };
    return is_out;
}


fn prod<T, MAG, +Drop<T>, +Copy<T>, +NumberTrait<T, MAG>, +TensorTrait<T>, +Mul<T>,>(
    pA: Span<T>, start: usize
) -> T {
    let mut i = start;
    let mut prod = NumberTrait::one();
    loop {
        if i == pA.len() {
            break;
        }
        prod = prod * (*pA.at(i));
        i += 1;
    };
    return prod;
}

