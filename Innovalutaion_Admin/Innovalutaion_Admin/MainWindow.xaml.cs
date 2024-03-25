using Firebase.Auth;
using Google.Cloud.Firestore;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Innovalutaion_Admin
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private bool isLoggedIn = false;
        private string errorMessage = "";

        public string b = "banana";

        public MainWindow()
        {
            InitializeComponent();
            K.firestoreDB = connect2FirestoreDB();

            Uri loginPage = new("Pages/LoginPage.xaml", UriKind.Relative),
                errorPage = new("Pages/ErrorPage.xaml", UriKind.Relative);
            //navFrame.Navigate((K.firestoreDB == null) ? errorPage, errorMessage : loginPage) ;

            if (K.firestoreDB == null)
            {
                navFrame.Navigate(errorPage, errorMessage);
            } else
            {
                navFrame.Navigate(loginPage);
            }

            
            
        }

        private void onWindowLoad(object Sender, RoutedEventArgs e)
        {

        }

        private void button_Click(object sender, RoutedEventArgs e)
        {
            var tag = ((Button)sender).Content;

            //Remember that we will need to wrap this in a statement that checks if user is logged in

            if (tag == homeButton.Content)
            {
                //Take us to the home page
                navFrame.Navigate(new Pages.HomePage(), UriKind.Relative);
            } else if (tag == createPatientButton.Content)
            {
                //this will take us to a page that will allow administrators to create new users for the flutter app
                navFrame.Navigate(new Pages.NewPatientPage(), UriKind.Relative);
            } else if (tag == viewPatientsButton.Content)
            {
                //I feel like this one if probably self-explanatory
                navFrame.Navigate(new Pages.PatientDataPage(), UriKind.Relative);
            }
            //There might be some more that we throw up in here as well. So let's leave this open for the time being.
        }

        FirestoreDb? connect2FirestoreDB()
        {
            try
            {
                Environment.SetEnvironmentVariable(K.googleAppCredentials, K.firebaseServiceAccountKeyPath);
                var db = FirestoreDb.Create(K.firebaseProjectID);
                MessageBox.Show("Sucess!");
                return db;
            }
            catch (Exception ex)
            {
                errorMessage = ex.Message;
                MessageBox.Show(ex.Message);
                return null;
            }

        }

    }
}