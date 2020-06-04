%module Example

%{
  #include "example.h"
%}

%import "eigen.i"

// Import other C# modules
%pragma(csharp) moduleimports=%{
using Eigen;
%}

%include "example.h"
