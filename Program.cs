using HyperMaxDrinksApp.Data;
using HyperMaxDrinksApp.Forms;

namespace HyperMaxDrinksApp
{
    internal static class Program
    {
        [STAThread]
        static void Main()
        {
            ApplicationConfiguration.Initialize();

            // ── Verify the database connection before opening any form ──
            if (!DatabaseHelper.TestConnection(out string error))
            {
                MessageBox.Show(
                    $"Cannot connect to the database.\n\n{error}\n\n" +
                    "Please check the Server and Database values in DatabaseHelper.cs.",
                    "Database Connection Error",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
                return;
            }

            Application.Run(new LoginForm());
        }
    }
}
