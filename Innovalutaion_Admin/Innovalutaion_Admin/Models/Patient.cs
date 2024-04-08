using Google.Cloud.Firestore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Innovalutaion_Admin.Models
{
    [FirestoreData]
    public class Patient
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
            this.questionnaireCompleted = (inputVals.ContainsKey("questionnaireCompleted")) ? inputVals["questionnaireCompleted"] : false;

            if (questionnaireCompleted)
            {
                Dictionary<string, dynamic> temp = inputVals["Answers"];
                questionnaireAnswers = new();

                foreach(var answer in temp)
                {
                    bool valAsBool = (bool)answer.Value;
                    questionnaireAnswers.Add(answer.Key, valAsBool);

                }

            } else
            {
                questionnaireAnswers = null;
            }

            this.photoLocations = new string[0];
            
            if (hasTakenInitialPhoto)
            {
                List<object> l = inputVals["photosList"];
                this.photoLocations = l!.Select(x => x.ToString()).ToArray();
            }


        }
    }
}
