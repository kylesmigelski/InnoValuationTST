using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Innovalutaion_Admin.Models
{
    public struct PatientTemplate
    {
        public string username { get; private set; }
        public string uuid { get; private set; }
        public string createdBy { get; private set; }

        public DateTime dateCreated { get; private set; }

        public PatientTemplate(string uuid, string username, string createdBy)
        {
            this.username = username;
            this.uuid = uuid;
            this.createdBy = createdBy;
            dateCreated = DateTime.Now;
        }
    }
}
