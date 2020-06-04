using Eigen;

class Program
{
    static void Print(float[,] M)
    {
        var rowCount = M.GetLength(0);
        var colCount = M.GetLength(1);
        for (int row = 0; row < rowCount; row++)
        {
            for (int col = 0; col < colCount; col++)
                System.Console.Write(System.String.Format("{0} ", M[row, col]));
            System.Console.WriteLine();
        }
    }

    public static int Main()
    {
        Matrix3f M3 = new Matrix3f();
        M3.Set(0, 0, 1);
        M3[2, 2] = 1;
        Example.print(M3);

        var D2 = new float[2, 2] { { 0.0f, 1.0f }, { 2.0f, 3.0f } };
        var M2 = new Matrix2f(D2);
        Example.print(M2);

        var D23 = new float[2, 3] { { 0.0f, 1.0f, 2.0f }, { 3.0f, 4.0f, 5.0f } };
        var M23 = new MatrixXf(D23);
        Example.print(M23);

        var S = new float[2, 3];
        M23.CopyTo(S);
        Print(S);
        var T = new float[1, 1] { { 0.0f} };
        M23.CopyTo(ref T);
        Print(T);

        return 0;
    }
}
