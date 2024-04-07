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
        private List<Patient> patientList;

        public PatientDataPage()
        {
            InitializeComponent();
            patientList = new();
            getDocuments();
        }

        async void getDocuments()
        {
            Query usersQuery = K.firestoreDB.Collection("users").WhereEqualTo("createdBy", _firebaseAuthLink.User.LocalId);
            QuerySnapshot dataSnapshot = await usersQuery.GetSnapshotAsync();


            foreach (DocumentSnapshot docsnap in dataSnapshot.Documents)
            {
                //MessageBox.Show(docsnap.ToDictionary().ToString());
                //string dictAsString = "";
                //dictAsString = string.Join(Environment.NewLine, docsnap.ToDictionary().Select(kv => $"{kv.Key} : {kv.Value}"));
                //MessageBox.Show(dictAsString);
                Patient patient = new(docsnap.ToDictionary());
                patientList.Add(patient);
                patientGridView.Items.Add(patient);

            }
        }

    }

    [FirestoreData]
    internal class Patient
    {
        [FirestoreProperty]
        public string username { get; set; }

        public string uuid { get; set; }
        
        public Timestamp dateCreated { get; set; }
      
        public Timestamp twoDayWindow { get; set; }
      
        public Timestamp threeDayWindow { get; set; }
  
        public bool hasTakenInitialPhoto { get; set; }
  
        public bool hasTakenFollowUpPhoto { get; set; }

        public bool hasHadFaceVerification { get; set; }
      
        public bool questionnaireCompleted { get; set; }

        public Dictionary<String, bool>? questionnaireAnswers { get; set; }
        
        public string[] photoLocations { get; set; }


        public Patient(Dictionary<string, dynamic> inputVals)
        {
            this.username = inputVals["username"];
            this.uuid = inputVals["uuid"];
            this.dateCreated = inputVals["dateCreated"];
            this.twoDayWindow = inputVals["48hourboundary"];
            this.threeDayWindow = inputVals["72HourBoundary"];
            this.hasTakenInitialPhoto = inputVals["initialPhotoTaken"];
            this.hasTakenFollowUpPhoto = inputVals["followUpPhotoTaken"];
            this.hasHadFaceVerification = inputVals["faceVerified"];
            this.questionnaireCompleted = (inputVals.ContainsKey("questionnaireCompleted")) ? inputVals["questionnaireCompleted"] : false ;

            this.questionnaireAnswers = (questionnaireCompleted == true) ? inputVals["Answers"] as Dictionary<string, bool> : null;
            this.photoLocations = (hasTakenInitialPhoto == true) ? inputVals["photosList"] as string[] : new string[0];


        }
    }
}
