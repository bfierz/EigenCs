
#include <iostream>

#include "example.h"

void print(const Eigen::Vector2f& M)
{
	std::cout << "Matrix (" << M.rows() << ", " << M.cols() << "): " << std::endl;
	std::cout << M << std::endl;
}

void print(const Eigen::Vector3f& M)
{
	std::cout << "Matrix (" << M.rows() << ", " << M.cols() << "): " << std::endl;
	std::cout << M << std::endl;
}

void print(const Eigen::Vector4f& M)
{
	std::cout << "Matrix (" << M.rows() << ", " << M.cols() << "): " << std::endl;
	std::cout << M << std::endl;
}
void print(const Eigen::VectorXf& M)
{
	std::cout << "Matrix (" << M.rows() << ", " << M.cols() << "): " << std::endl;
	std::cout << M << std::endl;
}

void print(const Eigen::Matrix2f& M)
{
	std::cout << "Matrix (" << M.rows() << ", " << M.cols() << "): " << std::endl;
	std::cout << M << std::endl;
}

void print(const Eigen::Matrix3f& M)
{
	std::cout << "Matrix (" << M.rows() << ", " << M.cols() << "): " << std::endl;
	std::cout << M << std::endl;
}

void print(const Eigen::Matrix4f& M)
{
	std::cout << "Matrix (" << M.rows() << ", " << M.cols() << "): " << std::endl;
	std::cout << M << std::endl;
}

void print(const Eigen::MatrixXf& M)
{
	std::cout << "Matrix (" << M.rows() << ", " << M.cols() << "): " << std::endl;
	std::cout << M << std::endl;
}
