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
using Innovalutaion_Admin.Models;

namespace Innovalutaion_Admin.Pages
{
    /// <summary>
    /// Interaction logic for CreatePatientPage.xaml
    /// </summary>
    public partial class CreatePatientPage : Page
    {
        FirebaseAuthProvider _firebaseAuthProvider = ((App) Application.Current).firebaseAuthProvider();
        FirebaseAuthLink? _firebaseAuthLink = ((App)Application.Current).firebaseAuthLink;
        public CreatePatientPage()
        {
            InitializeComponent();
        }

        private async void submitButton_Click(object sender, RoutedEventArgs e)
        {
            if (!allFieldsValid())
                return;

            //First catch. Making sure the user is still logged in.
            if (_firebaseAuthLink != null)
            {
                string username = usernameTextBox.Text;

                if (await userAlreadyExists(username) == false)
                {
                    if (await createNewUserAccount(username))
                    {
                        MessageBox.Show("Account Created Successfully");
                        this.NavigationService.Navigate(new HomePage(), UriKind.Relative);
                    }
                }

            } else
            {
                MessageBox.Show("It appears you're currently logged out. You should not have been able to access this.");
                this.NavigationService.Navigate(new LoginPage(), UriKind.Relative);
            }
        }

        bool allFieldsValid()
        {
            //TODO -- Implement
            return true;
            return false;
        }

        async Task<bool> createNewUserAccount(string username)
        {
            try
            {
                var useremail = String.Format("{0}@test.com", username);
                string password = passwordBox1.Text;

                DateTime dateTimeCreated = DateTime.Now;


                Timestamp timestampCreated = Timestamp.FromDateTime(DateTime.SpecifyKind(dateTimeCreated, DateTimeKind.Utc)),
                    earlyBound = Timestamp.FromDateTime(DateTime.SpecifyKind(dateTimeCreated.AddHours(48), DateTimeKind.Utc)),
                    lateBound = Timestamp.FromDateTime(DateTime.SpecifyKind(dateTimeCreated.AddHours(72), DateTimeKind.Utc));

                //First we create the "email" account.
                await _firebaseAuthProvider.CreateUserWithEmailAndPasswordAsync(useremail, password);

                //Now we need to sign in with it
                var tempLink = await _firebaseAuthProvider.SignInWithEmailAndPasswordAsync(useremail, password);

                var newUserUID = tempLink.User.LocalId;

                Google.Cloud.Firestore.DocumentReference newUserReference = K.firestoreDB!.Collection("users")
                    .Document(newUserUID);

                Dictionary<string, object> newUserTemplate = new()
                {
                    { "uuid" , newUserUID },
                    { "username", username },
                    { "createdBy", _firebaseAuthLink.User.LocalId },
                    { "dateCreated", timestampCreated },
                    { "48hourboundary", earlyBound },
                    { "72HourBoundary", lateBound },
                    { "initialPhotoTaken", false },
                    { "canTakeFollowUpPhoto", false },
                    { "followUpPhotoTaken", false },
                    { "notification20HoursSent", false },
                    { "notification23HoursSent", false },
                    { "faceVerified", false }
                };

                await newUserReference.SetAsync(newUserTemplate);

                return true;

            } 
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                return false;
            } 
        }

        async Task<bool> userAlreadyExists(string username)
        {
            QuerySnapshot validUsername = await K.firestoreDB!.Collection("users").WhereEqualTo("username", username).GetSnapshotAsync();

            if (validUsername.Documents.Count != 0)
            {
                MessageBox.Show("Error! Username already exists");
                return true;
            }
            return false;
        }
        
    }
}
