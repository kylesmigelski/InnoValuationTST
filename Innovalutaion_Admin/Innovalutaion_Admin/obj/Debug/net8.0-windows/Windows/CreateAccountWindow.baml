   M S B A M L   `   `   `  ����N  JInnovalutaion_Admin, Version=1.0.0.0, Culture=neutral, PublicKeyToken=nullI)clr-namespace:Innovalutaion_Admin.WindowsInnovalutaion_Admin.Windows  5   	   5    /Innovalutaion_Admin.Windows.CreateAccountWindow   5   	   W SPresentationCore, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35e aSystem.Windows.Controls.Ribbon, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089R NWindowsBase, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35F 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     5   	   R NSystem.Xaml, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   ;local)clr-namespace:Innovalutaion_Admin.Windows     5   	     � Title$  CreateAccountWindow��5   	   $	��450��6%   $	��800��62   .��5	      �  � RowDefinitions 5
   
   �� 5      $
��0.4* �6   �� 5      .+�5   
   �� $��Innovaluation��6   $��Center=�6(   $��0,22,0,0q�6E   $	��Top=�6W   $��32(�6o   $
��Bold"�6}   � 5   
   $��1��6    � ColumnDefinitions 5      �� 5      $��1* �6#   �� 5      $��1* �6#   .+�5      �� $��Username��6   $
��Left=�6'   $��	45,30,0,0q�6B   $	��Top=�6U   �� 5      -   5         ��Name$ usernameTextBlock��5      $
��Left=�61   $��	50,61,0,0q�6L    �� TextWrapping$
 Wrap=�6_   $�� ��6s   $	��Top=�6{   $	��120��6�   �� 5      $��passowrd��6   $
��Left=�6'   $��
45,106,0,0q�6B   $	��Top=�6V   �� 5      -   5        $ 
passBlock1��5      $
��Left=�6*   $��
50,137,0,0q�6E   $
 Wrap=�6Y   $�� ��6m   $	��Top=�6u   $	��120��6�   �� 5      $��Repeat passowrd��6   $
��Left=�6.   $��
45,183,0,0q�6I   $	��Top=�6]   �� 5      -   5        $ 
passBlock2��5      $
��Left=�6*   $��
50,214,0,0q�6E   $
 Wrap=�6Y   $�� ��6m   $	��Top=�6u   $	��120��6�   � 5      $��1��6   .+�5      �� $��Name of TST site��6   $
��Left=�63   $��	45,30,0,0q�6N   $	��Top=�6a   �� 5      -   5        $ establishmentTextBlock��5      $
��Left=�6:   $��	50,61,0,0q�6U   $
 Wrap=�6h   $�� ��6|   $	��Top=�6�   $	��120��6�   �� 5       $��Email��6   $
��Left=�6(   $	��Top=�6C   $��
45,100,0,0q�6[   �� 5!      -   5        $ emailTextBox��5!      $
��Left=�60   $	��Top=�6K   $��
50,125,0,0q�6c   $	��120��6w   �� 5#      $��ZipCode��6   $
��Left=�6*   $	��Top=�6E   $��
45,180,0,0q�6]   �� 5$      -   5        $ zipcodeTextBox��5$      $
��Left=�62   $	��Top=�6M   $��
50,205,0,0q�6e   $	��120��6y   �� 5&      -   5         ��Name$ submitButton��5&      $��Submit��6/   $��Center=�6@   $��	0,254,0,0q�6]   $	��Top=�6p   $��27��6�   $��68��6�   6�   5(      5*      5,      5-      