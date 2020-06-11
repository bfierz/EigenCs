%module Example

%{
  #include "example.h"
%}

%import "eigen.i"

// C# prefers upper-case
%rename("%(firstuppercase)s", %$isfunction) "";

// Import other C# modules
%pragma(csharp) moduleimports=%{
using Eigen;
%}

%include "example.h"
