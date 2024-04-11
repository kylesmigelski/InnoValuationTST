using Innovalutaion_Admin.Windows;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

using Google.Cloud.Firestore;
using Firebase.Auth;
using System.Net.Mail;
using System.Security.Cryptography.X509Certificates;

namespace Innovalutaion_Admin.Pages
{
    /// <summary>
    /// Interaction logic for LoginPage.xaml
    /// </summary>
    public partial class LoginPage : Page
    {

        FirebaseAuthProvider _firebaseAuthProvider = ((App)Application.Current).firebaseAuthProvider();
        


        public LoginPage()
        {
            InitializeComponent();
            //K.firestoreDB = connect2FirestoreDB();
        }


        private void button_click(object sender, RoutedEventArgs e)
        {
            var tag = ((Button)sender).Content;

            if (tag == loginButton.Content)
            {
                //Have our login functionality happen here. This will basically be checking that the uname and pass fields
                // have stuff written in them, then making a call to the firebase database to see if a user account with those
                // credentials exists
                login(usernameTextBox.Text, passwordTextBox.Text);

            } else if (tag == createAccountButton.Content)
            {
                //Opening a new window seemed like the play here. But we will also need to pop some data back if we're going to try and then
                // log in with what we've got from CreateAccountWindow.
                CreateAccountWindow createAccountWindow = new();
                createAccountWindow.ShowDialog();
                if (((App)Application.Current).isLoggedIn)
                    go2HomePage();
                //var m = createAccountWindow.getB();
                //MessageBox.Show(m.ToString());
                //MessageBox.Show("Test");
                
            }
        }

        private async void login(string login, string password)
        {

            if (!isValidEmail(login))
            {
                MessageBox.Show("Invalid email detected");
                return;
            }

            try
            {
                QuerySnapshot validAdministrator = await K.firestoreDB!.Collection("administrators").WhereEqualTo("email", login).GetSnapshotAsync();

                if (validAdministrator.Documents.Count == 0) {
                    MessageBox.Show("Invalid Credentials Provided");
                    return;
                }
                //MessageBox.Show("Please wait while we try to log you in. Press OK to continue");

                ((App) Application.Current).firebaseAuthLink = await _firebaseAuthProvider.SignInWithEmailAndPasswordAsync(login, password);
                ((App)Application.Current).isLoggedIn = true;
                go2HomePage();
                Application.Current.Windows.OfType<MainWindow>().FirstOrDefault().setTextForLoginButton();
                
                
                
            } catch (Exception ex)
            {
                MessageBox.Show("Unable to log in. Reason: " + ex.Message);
            }
        }

        void go2HomePage()
        {
            if (((App) Application.Current).firebaseAuthLink != null)
            {
                ((App) Application.Current).isLoggedIn = true;
                Uri uri = new("Pages/HomePage.xaml", UriKind.Relative);
                this.NavigationService.Navigate(uri);

            }
        }
        bool isValidEmail(string email)
        {
            if (string.IsNullOrEmpty(email))
                return false;

            try
            {
                var emailAddress = new MailAddress(email);
            }
            catch
            {
                return false;
            }
            return true;
        }


        /*FirestoreDb? connect2FirestoreDB()
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
                MessageBox.Show(ex.Message);
                return null;
            }
        }*/
    }
}
