%module Eigen
%{
  #include <Eigen/Core>

  #include <type_traits>
  #include <vector>
%}

%include "attribute.i"

// Declare the namespace to place the generated output
// Note: This is currently not working as expected. The namespace passed as
//       argument to the generator.
%nspace Eigen;

// Eigen uses lower-case method names, C# prefers upper-case
%rename("%(firstuppercase)s", %$isfunction) "";

// Make internal method 'getCPtr' public to allow access from other modules
SWIG_CSBODY_PROXY(internal, public, SWIGTYPE)

// Basic C++ defintion for which bindings are generated
namespace Eigen
{
  // Stub of the Eigen types for which bindings should be generated
  template<typename Scalar, int I, int J>
  class Matrix
  {
  public:
    Matrix();

    long long cols() const;
    long long rows() const;

    Matrix operator+(const Matrix&) const;
    Matrix operator-(const Matrix&) const;
  };

  template<typename Scalar>
  class Matrix<Scalar,2,1>
  {
  public:
    Matrix();
    Matrix(float x, float y);

    long long cols() const;
    long long rows() const;

    Matrix operator+(const Matrix&) const;
    Matrix operator-(const Matrix&) const;
  };

  template<typename Scalar>
  class Matrix<Scalar,3,1>
  {
  public:
    Matrix();
    Matrix(float x, float y, float z);

    long long cols() const;
    long long rows() const;

	Matrix operator+(const Matrix&) const;
	Matrix operator-(const Matrix&) const;
  };

  template<typename Scalar>
  class Matrix<Scalar,4,1>
  {
  public:
    Matrix();
    Matrix(float x, float y, float z, float w);

    long long cols() const;
    long long rows() const;

    Matrix operator+(const Matrix&) const;
    Matrix operator-(const Matrix&) const;
  };

  using Vector2f = Matrix<float, 2, 1>;
  using Vector3f = Matrix<float, 3, 1>;
  using Vector4f = Matrix<float, 4, 1>;
  using Matrix2f = Matrix<float, 2, 2>;
  using Matrix3f = Matrix<float, 3, 3>;
  using Matrix4f = Matrix<float, 4, 4>;

  using VectorXf = Matrix<float, -1,  1>;
  using MatrixXf = Matrix<float, -1, -1>;
}

// Create extensions to the Matrix type for C#
%define eigen_typemap(SwigType, Scalar, NrRows, NrCols)

// Generate attributes for 'cols' and 'rows' intead of methods
%ignore Eigen::Matrix<Scalar, NrRows, NrCols>::cols() const;
%ignore Eigen::Matrix<Scalar, NrRows, NrCols>::rows() const;
%attribute(%arg(Eigen::Matrix<Scalar, NrRows, NrCols>), long long, Cols, cols);
%attribute(%arg(Eigen::Matrix<Scalar, NrRows, NrCols>), long long, Rows, rows);

%rename(Add) Eigen::Matrix<Scalar, NrRows, NrCols>::operator+;
%rename(Sub) Eigen::Matrix<Scalar, NrRows, NrCols>::operator-;

// C++ specific extensions as ()-operator is not available in C#
%extend Eigen::Matrix<Scalar, NrRows, NrCols> {

  %apply void* VOID_INT_PTR { Scalar* }
  void get(Scalar* values, int rows, int cols) {
    using ColMajorMatrix = Eigen::Matrix<Scalar, NrRows, NrCols, Eigen::ColMajor>;
    using RowMajorMatrix = Eigen::Matrix<Scalar, NrRows, NrCols, Eigen::RowMajor>;
    Eigen::Map<std::conditional<NrCols != 1, RowMajorMatrix, ColMajorMatrix>::type> tmp(values, rows, cols);
    tmp = *self;
  }
  void set(Scalar* values, int rows, int cols) {
    using ColMajorMatrix = Eigen::Matrix<Scalar, NrRows, NrCols, Eigen::ColMajor>;
    using RowMajorMatrix = Eigen::Matrix<Scalar, NrRows, NrCols, Eigen::RowMajor>;
    Eigen::Map<std::conditional<NrCols != 1, RowMajorMatrix, ColMajorMatrix>::type> tmp(values, rows, cols);
    *self = tmp;
  }
  %clear Scalar* values;

  Scalar get(int i, int j) const {
    return (*$self)(i, j);
  }
  void set(int i, int j, Scalar a) {
    (*$self)(i, j) = a;
  }

  // C# specific extensions to make the matrix type more C#-like
  %proxycode
  %{
  public SwigType(Scalar[,] values) : this() {
    var gch = System.Runtime.InteropServices.GCHandle.Alloc(values, System.Runtime.InteropServices.GCHandleType.Pinned);
    System.IntPtr ptr = gch.AddrOfPinnedObject();
    Set(ptr, values.GetLength(0), values.GetLength(1));
    gch.Free();
  }
  public void CopyTo(ref Scalar[,] values) {
    if (values.GetLength(0) != Rows || values.GetLength(1) != Cols) {
      values = new Scalar[Rows, Cols];
    }
	CopyTo(values);
  }
  public void CopyTo(Scalar[,] values) {
    var gch = System.Runtime.InteropServices.GCHandle.Alloc(values, System.Runtime.InteropServices.GCHandleType.Pinned);
    System.IntPtr ptr = gch.AddrOfPinnedObject();
    Get(ptr, values.GetLength(0), values.GetLength(1));
    gch.Free();
  }
  public Scalar this[int i, int j] {
    get {
      return Get(i, j);
    }
    set {
      Set(i, j, value);
    }
  }
  %}
}

// Instantiate C++ template for usage in C#
%template(SwigType) Eigen::Matrix<Scalar, NrRows, NrCols>;

%enddef

eigen_typemap(Vector2f, float, 2, 1)
eigen_typemap(Vector3f, float, 3, 1)
eigen_typemap(Vector4f, float, 4, 1)
eigen_typemap(Matrix2f, float, 2, 2)
eigen_typemap(Matrix3f, float, 3, 3)
eigen_typemap(Matrix4f, float, 4, 4)

eigen_typemap(VectorXf, float, -1,  1)
eigen_typemap(MatrixXf, float, -1, -1)

// Reset function naming
%rename("%s", %$isfunction) "";
