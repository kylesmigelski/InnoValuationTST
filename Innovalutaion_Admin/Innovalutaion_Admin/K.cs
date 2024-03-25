using Google.Cloud.Firestore.V1;
using System;
using System.CodeDom;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

namespace Innovalutaion_Admin
{
    public static class K
    {
        public static readonly string firebaseServiceAccountKeyPath = AppDomain.CurrentDomain.BaseDirectory
            + @"firebase_settings.json",

            firebaseProjectID = "innovaluation-tst",
            googleAppCredentials = "GOOGLE_APPLICATION_CREDENTIALS";

        public static FirestoreDb? firestoreDB = null;
    }
}
