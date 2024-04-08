using Google.Cloud.Firestore;
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
using System.Windows.Shapes;

namespace Innovalutaion_Admin.Windows
{
    /// <summary>
    /// Interaction logic for PatientWindow.xaml
    /// </summary>
    public partial class PatientWindow : Window
    {
        Models.Patient patient;

        private List<BitmapImage> images;
        private int imageIndex = 0;
        private bool hasTB;

        public PatientWindow(Models.Patient patient)
        {
            InitializeComponent();
            this.patient = patient;

            setupQuestionnaireTextBlock();
            setupImages4Viewing();

        }

        private async void button_click(object sender, RoutedEventArgs e)
        {
            var tag = ((Button)sender).Content;

            if (tag == nextButton.Content)
            {
                imageIndex = (imageIndex < images.Count - 1) ? imageIndex + 1 : 0;
                imageView.Source = images[imageIndex];
            } else if (tag == backButton.Content)
            {
                imageIndex = (imageIndex == 0) ? images.Count - 1 : imageIndex - 1;
                imageView.Source = images[imageIndex];
            } else if (tag == finishButton.Content)
            {
                MessageBoxResult dialogResult = MessageBox.Show("After viewing these images, do you have reason to belive that this person may be TB positive? (Click yes if you are unsure)", "Finish", MessageBoxButton.YesNoCancel);
                if (dialogResult == MessageBoxResult.Yes)
                {
                    hasTB = true;
                    await updatePatientTBStatus();
                    Close();
                } else if (dialogResult == MessageBoxResult.No)
                {
                    hasTB = false;
                    await updatePatientTBStatus();
                    Close();
                }
            }


        }

        private async Task updatePatientTBStatus()
        {
            QuerySnapshot qs = await K.firestoreDB!.Collection("users").WhereEqualTo("uuid", patient.uuid).GetSnapshotAsync();
            Google.Cloud.Firestore.DocumentReference docref = qs.Documents.First().Reference;

            await docref.SetAsync(new Dictionary<string, object> { { "hasTB", hasTB } }, SetOptions.MergeAll);
            
        }

        private void setupQuestionnaireTextBlock()
        {
            quesstionnaireTextBlock.Text = "";

            if (patient.questionnaireCompleted == false)
            {
                quesstionnaireTextBlock.Text = "Patient has not yet taken their questionnaire";
                return;
            }

            foreach (var answer in patient.questionnaireAnswers!)
            {
                quesstionnaireTextBlock.Inlines.Add(new Run(answer.Key + ": "));
                quesstionnaireTextBlock.Inlines.Add(new Bold(new Run(patient.questionnaireAnswers![answer.Key] ? "Yes" : "No")));
                quesstionnaireTextBlock.Inlines.Add(new LineBreak());
            }
        }

        private void setupImages4Viewing()
        {
            if (patient.hasTakenInitialPhoto == false)
            {
                return;
            }
            images = new();
            
            if (patient.photoLocations.Length > 0)
            {
                int i = 0;
                foreach (string location in patient.photoLocations)
                {
                    Image image = new();
                    var fullFilePath = patient.photoLocations[i++];

                    BitmapImage bitmap = new BitmapImage();
                    bitmap.BeginInit();
                    bitmap.UriSource = new Uri(fullFilePath, UriKind.Absolute);
                    bitmap.EndInit();

                    images.Add(bitmap);
                }

                imageView.Source = images[imageIndex];
            }
        }
    }
}
