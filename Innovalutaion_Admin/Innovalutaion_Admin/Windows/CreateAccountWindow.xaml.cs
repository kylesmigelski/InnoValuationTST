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
        private FirebaseAuthLink? firebaseAuthLink = ((App) Application.Current).firebaseAuthLink;
        public FirebaseAuthLink? getFirebaseAuthLink() => firebaseAuthLink;
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
                email = emailTextBox.Text,
                zip = zipcodeTextBox.Text;

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

            if (!isValidZipCode(zip))
            {
                MessageBox.Show("Invalid Zipcode detected");
                return;
            }
            
            if (await createUser(username, pass, email, tstSiteName, zip))
            {
                MessageBox.Show(string.Format("Accound {0} successfully created!", username), "Success");
                //So here we'll want it to then send data up to the cloud firestore database, then pop relevant info back to the login page
                //in order to then immediately log in so that the user isn't stuck having to enter their information in a second time
                // like some kind of chump.
                ((App)Application.Current).isLoggedIn = true;


                //But for now we can just have this one exit
                Close();
            }

        }

        private async Task<bool> createUser(string username, string pass, string email, string tstSiteName, string zip)
        {
          try
            {
                await _firebaseAuthProvider.CreateUserWithEmailAndPasswordAsync(email, pass);
                //Actually, let's log in first so that we can grab the UUID
                firebaseAuthLink =  await _firebaseAuthProvider.SignInWithEmailAndPasswordAsync(email, pass);
                //Now let's add the references to our firebase database in order to classify this is an administrator account and not a patient
                //accout

                MessageBox.Show(firebaseAuthLink.User.LocalId);
                var uuid = firebaseAuthLink.User.LocalId;

                Google.Cloud.Firestore.DocumentReference adminCollection = K.firestoreDB!.Collection("administrators")
                    .Document(String.Format("{0} - {1}", username, uuid));

                Dictionary<string, object> adminData = new()
                {
                    {"uuid", uuid },
                    {"username", username},
                    {"email", email},
                    {"tstsitename", tstSiteName },
                    { "zipcode", zip }
                };

                await adminCollection.SetAsync(adminData);
                
               
                return true;
            } catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                return false;
            }
        }

        private bool isValidZipCode(string code)
        {
            var allowedChars = "0123456789-";
            if (code.All(x => allowedChars.Contains(x)) && code.Length == 5)
                return true;
            return false;
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
