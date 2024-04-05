using Firebase.Auth;
//using Firebase.Auth.Providers;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System.Configuration;
using System.Data;
using System.Windows;

namespace Innovalutaion_Admin
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        private readonly IHost _host;
        private FirebaseAuthProvider _provider;
        private bool _isLoggedIn = false;
        private FirebaseAuthLink? _currentFirebaseAuthLink = null;

        public FirebaseAuthLink? firebaseAuthLink
        {
            get => _currentFirebaseAuthLink; set => _currentFirebaseAuthLink = value;
        }

        public bool isLoggedIn
        {
            get => _isLoggedIn; set => _isLoggedIn = value;
        }
        //Firebase.Auth.FirebaseAuthConfig _config;

        //This dependency injection may not actually be necessary. But it seems like this might be helpful in getting the different
        // firebase services to work on our program
        public App()
        {

            //Environment.SetEnvironmentVariable(K.googleAppCredentials, K.firebaseServiceAccountKeyPath);
            _host = Host.CreateDefaultBuilder()
               .ConfigureServices((context, service) =>
               {
                   string firebaseWebAPIKEy = context.Configuration.GetValue<string>("FIREBASE_WEB_API_KEY");
                   //Console.WriteLine(firebaseWebAPIKEy);
                   
                   service.AddSingleton(new FirebaseAuthProvider(new FirebaseConfig(firebaseWebAPIKEy!)));

                   service.AddSingleton<MainWindow>((services) => new MainWindow()) ; 
               }).Build();
        }

        protected override async void OnStartup(StartupEventArgs e)
        {
            await _host.StartAsync();

            //FirebaseAuthProvider firebaseAuthProvider = _host.Services.GetRequiredService<FirebaseAuthProvider>();
            _provider = _host.Services.GetRequiredService<FirebaseAuthProvider>();
            MainWindow = _host.Services.GetRequiredService<MainWindow>();
            MainWindow.Show();

           
            //firebaseAuthProvider.CreateUserWithEmailAndPasswordAsync("admin@admin.com", "Test1234");

            base.OnStartup(e);
        }

        protected override async void OnExit(ExitEventArgs e)
        {
            await _host.StopAsync();
            base.OnExit(e);
        }

        public FirebaseAuthProvider firebaseAuthProvider()
        {
            return _provider;
        }

    }

}
