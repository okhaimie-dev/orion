use orion::operators::tensor::core::Tensor;

/// Trait
///
/// relu - Applies the rectified linear unit function element-wise.
/// leaky_relu - Applies the leaky rectified linear unit (Leaky ReLU) activation function element-wise.
/// sigmoid - Applies the Sigmoid function to an n-dimensional input tensor.
/// softmax - Computes softmax activations.
/// logsoftmax - Applies the natural log to Softmax function to an n-dimensional input Tensor.
/// softsign - Applies the Softsign function element-wise.
/// softplus - Applies the Softplus function element-wise.
/// linear - Performs a linear transformation of the input tensor using the provided weights and bias.
/// hard_sigmoid - Applies the Hard Sigmoid function to an n-dimensional input tensor.
/// thresholded_relu - Performs the thresholded relu activation function element-wise.
/// gemm - Performs General Matrix multiplication.
/// nonmaxsuppression - Performs Non Maximum Suppression.
trait NNTrait<T> {
    /// # NNTrait::relu
    ///
    /// ```rust 
    ///    fn relu(tensor: @Tensor<T>) -> Tensor<T>;
    /// ```
    /// 
    /// Applies the rectified linear unit function element-wise
    /// 
    /// $$
    /// ReLU(x)=(x)^+=max(0,x)
    /// $$
    /// 
    /// ## Args
    ///
    /// * `tensor`(`@Tensor<T>`) - The input tensor.
    ///
    /// ## Returns
    /// 
    /// A `Tensor<T>` with the same shape as the input tensor.
    ///
    /// ## Examples
    /// 
    /// ```rust
    /// use array::{ArrayTrait, SpanTrait};
    /// 
    /// use orion::operators::tensor::{TensorTrait, Tensor, I32Tensor};
    /// use orion::operators::nn::{NNTrait, I32NN};
    /// use orion::numbers::{i32, IntegerTrait};
    /// 
    /// fn relu_example() -> Tensor<i32> {
    ///     let tensor = TensorTrait::<i32>::new(
    ///         shape: array![2, 2].span(),
    ///         data: array![
    ///             IntegerTrait::new(1, false),
    ///             IntegerTrait::new(2, false),
    ///             IntegerTrait::new(1, true),
    ///             IntegerTrait::new(2, true),
    ///         ]
    ///             .span(),
    ///     );
    /// 
    ///     return NNTrait::relu(@tensor);
    /// }
    /// >>> [[1,2],[0,0]]
    /// ```
    /// 
    fn relu(tensor: @Tensor<T>) -> Tensor<T>;
    /// # NNTrait::softmax
    ///
    /// ```rust 
    ///    fn softmax(tensor: @Tensor<T>, axis: usize) -> Tensor<T>;
    /// ```
    ///
    /// Applies the Softmax function to an n-dimensional input Tensor rescaling them so that the elements of the n-dimensional output Tensor lie in the range \[0,1] and sum to 1.
    /// 
    /// $$
    /// \text{softmax}(x_i) = \frac{e^{x_i}}{\sum_{j=1}^n e^{x_j}}
    /// $$
    /// 
    /// ## Args
    ///
    /// * `tensor`(`@Tensor<T>`) - The input tensor.
    /// * `axis`(`usize`) - The axis along which to compute the softmax.
    ///
    /// ## Returns
    ///
    /// A Tensor of fixed point numbers with the same shape than the input Tensor.
    ///
    /// ## Type Constraints
    ///
    /// Constrain input and output types to fixed point tensors.
    ///
    /// ## Examples
    /// 
    /// ```rust
    /// use array::{ArrayTrait, SpanTrait};
    /// 
    /// use orion::operators::tensor::{TensorTrait, Tensor, FP8x23};
    /// use orion::operators::nn::{NNTrait, FP8x23NN};
    /// use orion::numbers::{FP8x23, FixedTrait};
    /// 
    /// fn softmax_example() -> Tensor<FP8x23> {
    ///     let tensor = TensorTrait::<FP8x23>::new(
    ///         shape: array![2, 2].span(),
    ///         data: array![
    ///             NNTrait::new(0, false),
    ///             NNTrait::new(1, false),
    ///             NNTrait::new(2, false),
    ///             NNTrait::new(3, false),
    ///         ]
    ///             .span(),
    ///     );
    /// 
    ///     return NNTrait::softmax(@tensor, 1);
    /// }
    /// >>> [[2255697,6132911],[2255697,6132911]]
    ///     // The fixed point representation of
    ///     // [[0.2689, 0.7311],[0.2689, 0.7311]]
    /// ```
    ///
    fn softmax(tensor: @Tensor<T>, axis: usize) -> Tensor<T>;
    /// # NNTrait::logsoftmax
    ///
    /// ```rust 
    ///    fn logsoftmax(tensor: @Tensor<T>, axis: usize) -> Tensor<T>
    /// ```
    ///
    /// Applies the natural log to Softmax function to an n-dimensional input Tensor consisting of values in the range \[0,1].
    /// 
    /// $$
    /// \text{log softmax}(x_i) = \log(frac{e^{x_i}}{\sum_{j=1}^n e^{x_j}})
    /// $$
    /// 
    /// ## Args
    ///
    /// * `tensor`(`@Tensor<T>`) - The input tensor.
    /// * `axis`(`usize`) - The axis along which to compute the natural lof softmax outputs.
    ///
    /// ## Returns
    ///
    /// A Tensor of fixed point numbers with the same shape than the input Tensor.
    ///
    /// ## Type Constraints
    ///
    /// Constrain input and output types to fixed point tensors.
    ///
    /// ## Examples
    /// 
    /// ```rust
    /// use array::{ArrayTrait, SpanTrait};
    /// 
    /// use orion::operators::tensor::{TensorTrait, Tensor, FP8x23};
    /// use orion::operators::nn::{NNTrait, FP8x23NN};
    /// use orion::numbers::{FP8x23, FixedTrait};
    /// 
    /// fn logsoftmax_example() -> Tensor<FP8x23> {
    ///     let tensor = TensorTrait::<FP8x23>::new(
    ///         shape: array![2, 2].span(),
    ///         data: array![
    ///             FixedTrait::new(0, false),
    ///             FixedTrait::new(1, false),
    ///             FixedTrait::new(2, false),
    ///             FixedTrait::new(3, false),
    ///         ]
    ///             .span(),
    ///     );
    /// 
    ///     return NNTrait::logsoftmax(@tensor, 1);
    /// }
    ///     This will first generate the softmax output tensor
    /// >>> [[2255697,6132911],[2255697,6132911]]
    ///     // The fixed point representation of
    ///     // [[0.2689, 0.7311],[0.2689, 0.7311]]
    ///     
    ///     Applying the natural log to this tensor yields
    /// >>> 
    ///     // The fixed point representation of:
    ///     // [[-1.3134, -0.3132],[-1.3134, -0.3132]]
    /// ```
    ///
    fn logsoftmax(tensor: @Tensor<T>, axis: usize) -> Tensor<T>;
    /// # NNTrait::sigmoid
    ///
    /// ```rust 
    ///    fn sigmoid(tensor: @Tensor<T>) -> Tensor<T>;
    /// ```
    ///
    /// Applies the Sigmoid function to an n-dimensional input tensor rescaling them so that the elements of the n-dimensional output Tensor lie in the range \[0,1].
    /// 
    /// $$
    /// \text{sigmoid}(x_i) = \frac{1}{1 + e^{-x_i}}
    /// $$
    /// 
    /// ## Args
    ///
    /// * `tensor`(`@Tensor<T>`) - The input tensor.
    ///
    /// ## Returns
    ///
    /// A Tensor of fixed point numbers with the same shape than the input Tensor.
    ///
    /// ## Type Constraints
    ///
    /// Constrain input and output types to fixed point tensors.
    ///
    /// ## Examples
    /// 
    /// ```rust
    /// use array::{ArrayTrait, SpanTrait};
    /// 
    /// use orion::operators::tensor::{TensorTrait, Tensor, FP8x23};
    /// use orion::operators::nn::{NNTrait, FP8x23NN};
    /// use orion::numbers::{FP8x23, FixedTrait};
    /// 
    /// fn sigmoid_example() -> Tensor<FP8x23> {
    ///     let tensor = TensorTrait::<FP8x23>::new(
    ///         shape: array![2, 2].span(),
    ///         data: array![
    ///             FixedTrait::new(0, false),
    ///             FixedTrait::new(1, false),
    ///             FixedTrait::new(2, false),
    ///             FixedTrait::new(3, false),
    ///         ]
    ///             .span(),
    ///     );
    /// 
    ///     return NNTrait::sigmoid(@tensor);
    /// }
    /// >>> [[4194304,6132564],[7388661,7990771]]
    ///     // The fixed point representation of
    ///     // [[0.5, 0.7310586],[0.88079703, 0.95257413]]
    /// ```
    ///
    fn sigmoid(tensor: @Tensor<T>) -> Tensor<T>;
    /// # NNTrait::softsign
    ///
    /// ```rust 
    ///    fn softsign(tensor: @Tensor<T>) -> Tensor<T>;
    /// ```
    ///
    /// Applies the Softsign function to an n-dimensional input Tensor such that the elements of the n-dimensional output Tensor lie in the range \[-1,1]. 
    /// 
    /// $$
    /// \text{softsign}(x_i) = \frac{x_i}{1 + |x_i|}
    /// $$
    /// 
    /// ## Args
    ///
    /// * `tensor`(`@Tensor<T>`) - The input tensor.
    ///
    /// ## Returns
    ///
    /// A Tensor of fixed point numbers with the same shape than the input Tensor.
    ///
    /// ## Type Constraints
    ///
    /// Constrain input and output types to fixed point tensors.
    ///
    /// ## Examples
    /// 
    /// ```rust
    /// use array::{ArrayTrait, SpanTrait};
    /// 
    /// use orion::operators::tensor::{TensorTrait, Tensor, FP8x23};
    /// use orion::operators::nn::{NNTrait, FP8x23NN};
    /// use orion::numbers::{FP8x23, FixedTrait};
    /// 
    /// fn softsign_example() -> Tensor<FP8x23> {
    ///     let tensor = TensorTrait::<FP8x23>::new(
    ///         shape: array![2, 2].span(),
    ///         data: array![
    ///             FixedTrait::new(0, false),
    ///             FixedTrait::new(1, false),
    ///             FixedTrait::new(2, false),
    ///             FixedTrait::new(3, false),
    ///         ]
    ///             .span(),
    ///     );
    /// 
    ///     return NNTrait::softsign(@tensor);
    /// }
    /// >>> [[0,4194304],[5592405,6291456]]
    ///     // The fixed point representation of
    ///     // [[0, 0.5],[0.67, 0.75]]
    /// ```
    ///
    fn softsign(tensor: @Tensor<T>) -> Tensor<T>;
    /// # NNTrait::softplus
    ///
    /// ```rust 
    ///    fn softplus(tensor: @Tensor<T>) -> Tensor<T>;
    /// ```
    ///
    /// Applies the Softplus function to an n-dimensional input Tensor such that the elements of the n-dimensional output Tensor lie in the range \[-1,1].
    /// 
    /// $$
    /// \text{softplus}(x_i) = log({1 + e^{x_i}})
    /// $$
    /// 
    /// ## Args
    ///
    /// * `tensor`(`@Tensor<T>`) - The input tensor.
    ///
    /// ## Returns
    ///
    /// A Tensor of fixed point numbers with the same shape than the input Tensor.
    ///
    /// ## Type Constraints
    ///
    /// Constrain input and output types to fixed point tensors.
    ///
    /// ## Examples
    /// 
    /// ```rust
    /// use array::{ArrayTrait, SpanTrait};
    /// 
    /// use orion::operators::tensor::{TensorTrait, Tensor, FP8x23};
    /// use orion::operators::nn::{NNTrait, FP8x23NN};
    /// use orion::numbers::{FP8x23, FixedTrait};
    /// 
    /// fn softplus_example() -> Tensor<FP8x23> {
    ///     let tensor = TensorTrait::<FP8x23>::new(
    ///         shape: array![2, 2].span(),
    ///         data: array![
    ///             FixedTrait::new(0, false),
    ///             FixedTrait::new(1, false),
    ///             FixedTrait::new(2, false),
    ///             FixedTrait::new(3, false),
    ///         ]
    ///             .span(),
    ///     );
    /// 
    ///     return NNTrait::softplus(@tensor);
    /// }
    /// >>> [[5814540,11016447],[17841964,25573406]]
    ///     // The fixed point representation of
    ///     // [[0.6931452, 1.31326096],[2.12692796, 3.04858728]]
    /// ```
    ///
    fn softplus(tensor: @Tensor<T>) -> Tensor<T>;
    /// # NNTrait::linear
    /// 
    /// ```rust
    /// fn linear(inputs: Tensor<T>, weights: Tensor<T>, bias: Tensor<T>) -> Tensor<T>
    /// ```
    /// 
    /// Performs a linear transformation of the input tensor using the provided weights and bias.
    ///
    /// ## Args
    ///
    /// * `tensor`(`@Tensor<T>`) - A 1D tensor representing the input tensor.
    /// * `weights`(`@Tensor<T>`) - A 2D tensor representing the weights.
    /// * `bias`(`@Tensor<T>`) - A 1D tensor representing the bias.
    ///
    /// ## Panics
    /// 
    /// * This function asserts that the input tensor `inputs` must be 1D, weights tensor must be 2D, and bias tensor must be 1D.
    ///
    /// ## Returns
    ///
    /// A `Tensor<T>` representing the result of the linear transformation.
    ///
    /// ## Examples
    ///
    /// ```rust
    /// use array::{ArrayTrait, SpanTrait};
    /// 
    /// use orion::operators::tensor::{TensorTrait, Tensor, I32Tensor};
    /// use orion::operators::nn::{NNTrait, I32NN};
    /// use orion::numbers::{i32, IntegerTrait};
    /// 
    /// fn linear_example() -> Tensor<i32> {
    ///     // We instantiate inputs here.
    ///     let inputs = TensorTrait::<i32>::new(
    ///         shape: array![3].span(),
    ///         data: array![
    ///             IntegerTrait::new(71, true), IntegerTrait::new(38, false), IntegerTrait::new(62, false),
    ///         ]
    ///             .span(),
    ///     );
    /// 
    ///     // We instantiate weights here.
    ///     let weights = TensorTrait::<i32>::new(
    ///         shape: array![2, 3].span(),
    ///         data: array![
    ///             IntegerTrait::new(8, true),
    ///             IntegerTrait::new(64, false),
    ///             IntegerTrait::new(40, false),
    ///             IntegerTrait::new(33, true),
    ///             IntegerTrait::new(34, true),
    ///             IntegerTrait::new(20, true),
    ///         ]
    ///             .span(),
    ///     );
    /// 
    ///     // We instantiate bias here.
    ///     let bias = TensorTrait::<i32>::new(
    ///         shape: array![2].span(),
    ///         data: array![IntegerTrait::new(61, false), IntegerTrait::new(61, true),].span(),
    ///     );
    /// 
    ///     return NNTrait::linear(inputs, weights, bias);
    /// }
    /// >>> [5541, -250]
    /// ````
    ///
    fn linear(inputs: Tensor<T>, weights: Tensor<T>, bias: Tensor<T>) -> Tensor<T>;
    /// # NNTrait::leaky_relu
    /// 
    /// ```rust
    ///  fn leaky_relu(inputs: @Tensor<T>, alpha: @T) -> Tensor<T>
    /// ```
    ///
    /// Applies the leaky rectified linear unit (Leaky ReLU) activation function element-wise to a given tensor.
    ///
    /// The Leaky ReLU function is defined as f(x) = alpha * x if x < 0, f(x) = x otherwise, where x is the input element.
    ///
    /// ## Args
    /// * `inputs`(`@Tensor<T>`) - A snapshot of a tensor to which the Leaky ReLU function will be applied.
    /// * `alpha`(`@T`) - A snapshot of a fixed point scalar that defines the alpha value of the Leaky ReLU function.
    ///
    /// ## Returns
    /// A new fixed point tensor with the same shape as the input tensor and the Leaky ReLU function applied element-wise.
    ///
    /// ## Type Constraints
    ///
    /// Constrain input and output types to fixed point tensors.
    ///
    /// ## Examples
    ///
    /// ```rust
    /// use array::{ArrayTrait, SpanTrait};
    /// 
    /// use orion::operators::tensor::{TensorTrait, Tensor, FP8x23};
    /// use orion::operators::nn::{NNTrait, FP8x23NN};
    /// use orion::numbers::{FP8x23, FixedTrait};
    /// 
    /// fn leaky_relu_example() -> Tensor<FP8x23> {
    ///     let tensor = TensorTrait::<FP8x23>::new(
    ///         shape: array![2, 3].span(),
    ///         data: array![
    ///             FixedTrait::new(1, false),
    ///             FixedTrait::new(2, false),
    ///             FixedTrait::new(1, true),
    ///             FixedTrait::new(2, true),
    ///             FixedTrait::new(0, false),
    ///             FixedTrait::new(0, false),
    ///         ]
    ///             .span(),
    ///     );
    ///     let alpha = FixedTrait::from_felt(838861); // 0.1
    /// 
    ///     return NNTrait::leaky_relu(@tensor, @alpha);
    /// }
    /// >>> [[8388608, 16777216, 838861], [1677722, 0, 0]]
    ///      // The fixed point representation of
    ///     [[1, 2, 0.1], [0.2, 0, 0]]
    /// ```
    /// 
    fn leaky_relu(inputs: @Tensor<T>, alpha: @T) -> Tensor<T>;
    /// # NNTrait::hard_sigmoid
    ///
    /// ```rust 
    ///    fn hard_sigmoid(tensor: @Tensor<T>, alpha: @T, beta: @T) -> Tensor<T>;
    /// ```
    ///
    /// Applies the HardSigmoid function to an n-dimensional input tensor.
    /// 
    /// $$
    /// \text{HardSigmoid}(x_i) = \text{max}(0, \text{min}(alpha * x + beta, 1))
    /// $$
    /// 
    /// ## Args
    ///
    /// * `tensor`(`@Tensor<T>`) - The input tensor.
    /// * `alpha`(`@T`) - value of alpha.
    /// * `beta`(`@T`) - value of beta.
    ///
    /// ## Returns
    ///
    /// A Tensor of fixed point numbers with the same shape than the input Tensor.
    ///
    /// ## Type Constraints
    ///
    /// Constrain input and output types to fixed point tensors.
    ///
    /// ## Examples
    /// 
    /// ```rust
    /// use array::{ArrayTrait, SpanTrait};
    /// 
    /// use orion::operators::tensor::{TensorTrait, Tensor, FP8x23};
    /// use orion::operators::nn::{NNTrait, FP8x23NN};
    /// use orion::numbers::{FP16x16, FixedTrait};
    /// 
    /// fn hard_sigmoid_example() -> Tensor<FP16x16> {
    ///     let tensor = TensorTrait::<FP16x16>::new(
    ///         shape: array![2, 2].span(),
    ///         data: array![
    ///             FixedTrait::new(0, false),
    ///             FixedTrait::new(13107, false),
    ///             FixedTrait::new(32768, false),
    ///             FixedTrait::new(65536, false),
    ///         ]
    ///             .span(),
    ///     );
    ///     let alpha = FixedTrait::new(13107, false);
    ///     let beta = FixedTrait::new(32768, false);
    /// 
    ///     return NNTrait::hard_sigmoid(@tensor, @alpha, @beta);
    /// }
    /// >>> [[32768, 35389],[39321, 45875]]
    /// ```
    ///
    fn hard_sigmoid(tensor: @Tensor<T>, alpha: @T, beta: @T) -> Tensor<T>;
    /// # NNTrait::thresholded_relu
    /// 
    /// ```rust
    ///  fn thresholded_relu(tensor: @Tensor<T>, alpha: @T) -> Tensor<T>
    /// ```
    ///
    /// Applies the thresholded rectified linear unit (Thresholded ReLU) activation function element-wise to a given tensor.
    ///
    /// The Thresholded ReLU function is defined as f(x) = x if x > alpha, f(x) = 0 otherwise, where x is the input element.
    ///
    /// ## Args
    /// * `tensor`(`@Tensor<T>`) - A snapshot of a tensor to which the Leaky ReLU function will be applied.
    /// * `alpha`(`@T`) - A snapshot of a fixed point scalar that defines the alpha value of the Thresholded ReLU function.
    ///
    /// ## Returns
    /// A new fixed point tensor with the same shape as the input tensor and the Thresholded ReLU function applied element-wise.
    ///
    /// ## Type Constraints
    ///
    /// Constrain input and output types to fixed point tensors.
    ///
    /// ## Examples
    ///
    /// ```rust
    /// use array::{ArrayTrait, SpanTrait};
    /// 
    /// use orion::operators::tensor::{TensorTrait, Tensor, FP8x23};
    /// use orion::operators::nn::{NNTrait, FP8x23NN};
    /// use orion::numbers::{FP8x23, FixedTrait};
    /// 
    /// fn thresholded_relu_example() -> Tensor<FP8x23> {
    ///     let tensor = TensorTrait::<FP8x23>::new(
    ///         shape: array![2, 2].span(),
    ///         data: array![
    ///             FixedTrait::new(0, false),
    ///             FixedTrait::new(256, false),
    ///             FixedTrait::new(512, false),
    ///             FixedTrait::new(257, false),
    ///         ]
    ///             .span(),
    ///     );
    ///     let alpha = FixedTrait::from_felt(256); // 1.0
    /// 
    ///     return NNTrait::leaky_relu(@tensor, @alpha);
    /// }
    /// >>> [[0, 0], [512, 257]]
    /// ```
    /// 
    fn thresholded_relu(tensor: @Tensor<T>, alpha: @T) -> Tensor<T>;
    /// # NNTrait::gemm
    /// 
    /// ```rust
    ///     fn gemm(
    ///         A: Tensor<T>,
    ///         B: Tensor<T>,
    ///         C: Option<Tensor<T>>,
    ///         alpha: Option<T>,
    ///         beta: Option<T>,
    ///         transA: bool,
    ///         transB: bool
    ///     ) -> Tensor<T>;
    /// ```
    /// 
    /// Performs General Matrix multiplication: https://en.wikipedia.org/wiki/Basic_Linear_Algebra_Subprograms#Level_3
    ///
    /// * A' = transpose(A) if transA else A
    /// * B' = transpose(B) if transB else B
    ///
    /// Compute `Y = alpha * A' * B' + beta * C`, where input tensor A has shape (M, K) or (K, M), input tensor B has shape (K, N) or (N, K), input tensor C is broadcastable to shape (M, N), and output tensor Y has shape (M, N).
    /// `A` will be transposed before doing the computation if attribute `transA` is `true`, same for `B` and `transB`.
    /// 
    /// ## Args
    ///
    /// * `A`(`Tensor<T>`) - Input tensor A. The shape of `A` should be (M, K) if `transA` is `false`, or (K, M) if `transA` is `true`.
    /// * `B`(`Tensor<T>`) - Input tensor B. The shape of `B` should be (K, N) if `transB` is `false`, or (N, K) if `transB` is `true`.
    /// * `C`(`Option<Tensor<T>>`) - Optional input tensor C. The shape of C should be unidirectional broadcastable to (M, N). 
    /// * `alpha`(`Option<T>`) - Optional scalar multiplier for the product of input tensors `A * B`.
    /// * `beta`(`Option<T>`) - Optional scalar multiplier for input tensor `C`.
    /// * `transA`(`bool`) - Whether `A` should be transposed.
    /// * `transB`(`bool`) - Whether `B` should be transposed.
    ///
    /// ## Returns
    ///
    /// A `Tensor<T>` of shape (M, N).
    ///
    /// ## Examples
    ///
    /// ```rust
    ///     mod input_0;
    ///     mod input_1;
    ///     mod input_2;
    ///     
    ///     use orion::operators::nn::NNTrait;
    ///     use orion::numbers::FixedTrait;
    ///     use orion::operators::nn::FP16x16NN;
    ///     use orion::operators::tensor::FP16x16TensorPartialEq;
    ///
    ///   fn gemm_all_attributes_example() -> Tensor<FP16x16> {
    ///       let input_0 = input_0::input_0(); // shape [4;3]
    ///       let input_1 = input_1::input_1(); // shape [5;4]
    ///       let input_2 = input_2::input_2(); // shape [1;5]
    ///
    ///       let y = NNTrait::gemm(
    ///           input_0,
    ///           input_1,
    ///           Option::Some(input_2),
    ///           Option::Some(FixedTrait::new(16384, false)), // 0.25
    ///           Option::Some(FixedTrait::new(22938, false)), // 0.35
    ///           true,
    ///           true
    ///       );
    ///
    ///       return y;
    ///   } 
    ///  >>> tensor of shape [3;5]
    /// ````
    ///
    fn gemm(
        A: Tensor<T>,
        B: Tensor<T>,
        C: Option<Tensor<T>>,
        alpha: Option<T>,
        beta: Option<T>,
        transA: bool,
        transB: bool
    ) -> Tensor<T>;
    fn nonmax_suppression(
        boxes: @Tensor<T>, 
        scores: @Tensor<T>, 
        max_output_boxes_per_class: Option<Tensor<T>>,
        iou_threshold: Option<Tensor<T>>,
        score_threshold: Option<Tensor<T>>,
        center_point_box: usize
    ) -> Tensor<T>;
}