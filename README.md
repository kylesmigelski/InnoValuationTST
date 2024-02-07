# w24-innovaluation

Description

## Link to powerpoint/presentation

https://docs.google.com/presentation/d/1KvPJH7rbwIJ2PSC104_kbgHvrTCx39CQc431Pyp68V8/edit#slide=id.g266e4bc1a73_0_403

### Important Notes for any current/future developers on this project using the Apple chipset

Installing Flutter packages via a computer with x86 architecture tends to set them up in a weird way where the Apple M-series machines won't be able to properly build out the project. So if you're running into issues where the command line is saying that the build failed to run pod install or pod update, just run these commands from the terminal in the ios directory of this project:

```
sudo arch -x86_64 gem install ffi
arch -x86_64 pod install
```

if it's still failing to build after that, then input:

```
arch -x86_64 pod install --repo-update
```

... after that, the thing should be able to build without issues. I don't know why installing packages on a flutter project from a silicon mac doesn't cause issues on x86 machines. But, having lost a lot of time cloning Flutter projects that had updates done on x86 machines to my M1 mac, I figure this will be helpful for future reference. Enjoy.
