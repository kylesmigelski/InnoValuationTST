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

namespace Innovalutaion_Admin
{
    /// <summary>
    /// Interaction logic for LoginPage.xaml
    /// </summary>
    public partial class LoginPage : Page
    {
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

            } else if (tag == createAccountButton.Content)
            {
                new CreateAccountWindow().Show();
            }
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
