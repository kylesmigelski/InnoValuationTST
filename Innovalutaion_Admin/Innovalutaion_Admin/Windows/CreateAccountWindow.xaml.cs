using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Globalization;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Net.Mail;
using Firebase.Auth;

namespace Innovalutaion_Admin.Windows
{
    /// <summary>
    /// Interaction logic for CreateAccountWindow.xaml
    /// </summary>
    public partial class CreateAccountWindow : Window
    {

        FirebaseAuthProvider _firebaseAuthProvider = ((App) Application.Current).firebaseAuthProvider();
        public CreateAccountWindow()
        {
            InitializeComponent();
            
        }

        private async void submitButton_Click(object sender, RoutedEventArgs e)
        {
            if (!(passBlock1.Text.Equals(passBlock2.Text)))
            {
                MessageBox.Show("Passwords do not match", "Error!");
                return;
            }

            string username = usernameTextBlock.Text,
                pass = passBlock1.Text,
                tstSiteName = establishmentTextBlock.Text,
                email = emailTextBox.Text;

            if (username.Length < 6)
            {
                MessageBox.Show("Username must be at least 6 characters long.", "Error!");
                return;
            }

            if (tstSiteName.Length < 6)
            {
                MessageBox.Show("Please input something valid into the TST site name", "Error!");
                return;
            }

            if (!isValidEmail(email))
            {
                MessageBox.Show("Invalid email detected!", "Error!");
                return;
            }

            //guess we should also check password
            if (!passWordIsValid(pass))
                return;

            //Should also maybe make a call up to the database here to make sure that the username doesn't already exist.
            //Then here we would probably want to make our call to the database to create our account
            //Might be able to merge that into a single async function call
            
            if (await createUser(username, pass, email))
            {
                MessageBox.Show(string.Format("Accound {0} successfully created!", username), "Success");
                //So here we'll want it to then send data up to the cloud firestore database, then pop relevant info back to the login page
                //in order to then immediately log in so that the user isn't stuck having to enter their information in a second time
                // like some kind of chump.


                //But for now we can just have this one exit
                Close();
            }

        }

        private async Task<bool> createUser(string username, string pass, string email)
        {
          try
            {
                await _firebaseAuthProvider.CreateUserWithEmailAndPasswordAsync(email, pass, username);
                return true;
            } catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                return false;
            }
        }

        bool passWordIsValid(string pass)
        {
            char[] specialChars = @"%!@#$^-_".ToCharArray();

            if (pass.Length >= 6 && pass.Where(char.IsUpper).Count() >= 2 &&
                pass.Where(char.IsLower).Count() >= 2 && pass.Where(char.IsNumber).Count() >= 2 &&
                pass.Where(c => specialChars.Contains(c)).Count() >= 2)
            {
                return true;
            }

            MessageBox.Show("Invalid password detected. Please ensure that your password has all of the following:" +
                "\n- 2 Uppercase Letters\n- 2 Lowercase Letters\n- 2 numbers\n- 2 of the characters %!@#$^-_", "Error!");
            return false;
        }

        bool isValidEmail(string email)
        {
            if (string.IsNullOrEmpty(email))
                return false;

            try
            {
                var emailAddress = new MailAddress(email);
            } catch
            {
                return false;
            }
            return true;
        }
        
    }
}
