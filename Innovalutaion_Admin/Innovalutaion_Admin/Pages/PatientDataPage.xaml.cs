using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
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
using Firebase.Auth;
using Google.Cloud.Firestore;

namespace Innovalutaion_Admin.Pages
{
    /// <summary>
    /// Interaction logic for PatientDataPage.xaml
    /// </summary>
    public partial class PatientDataPage : Page
    {
        private FirebaseAuthLink? _firebaseAuthLink = ((App)Application.Current).firebaseAuthLink;
        private List<Models.Patient> patientList;
        private int selectedRow = 0;

        public PatientDataPage()
        {
            InitializeComponent();
            getDocuments();
        }

        async void getDocuments()
        {
            patientList = new();
            Query usersQuery = K.firestoreDB.Collection("users").WhereEqualTo("createdBy", _firebaseAuthLink.User.LocalId);
            QuerySnapshot dataSnapshot = await usersQuery.GetSnapshotAsync();


            foreach (DocumentSnapshot docsnap in dataSnapshot.Documents)
            {
                //MessageBox.Show(docsnap.ToDictionary().ToString());
                //string dictAsString = "";
                //dictAsString = string.Join(Environment.NewLine, docsnap.ToDictionary().Select(kv => $"{kv.Key} : {kv.Value}"));
                //MessageBox.Show(dictAsString);
                Models.Patient patient = new(docsnap.ToDictionary());
                
                patientList.Add(patient);
                //patientGridView.Items.Add(patient);

            }

            patientGridView.ItemsSource = patientList;
        }

        private void patientGridView_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            selectedRow = patientGridView.SelectedIndex;
        }

        private void onRowDoubleClick(object sender, MouseButtonEventArgs e)
        {
            //MessageBox.Show("This event fired");
            Windows.PatientWindow patientWindow = new(patientList[selectedRow]);
            patientWindow.ShowDialog();
            getDocuments();

        }
    }
}
