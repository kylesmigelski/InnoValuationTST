   M S B A M L   `   `   `  ����N  JInnovalutaion_Admin, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null9!clr-namespace:Innovalutaion_AdminInnovalutaion_Admin  5   	   $    Innovalutaion_Admin.MainWindow   5   	   W SPresentationCore, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35e aSystem.Windows.Controls.Ribbon, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089R NWindowsBase, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35F 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     5   	   R NSystem.Xaml, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   3local!clr-namespace:Innovalutaion_Admin     5   	     � Title$  
MainWindow��5   	   $	��600��6   $
��1000��6)   $	��600��5	   	   $	��800��6   .��5
      �  � ColumnDefinitions 5   
   �� 5      $	��150 �6   �� 5      .+�5   
   �� ���#e9ecef.+�5      �� $��NavBar��6   $��Center=�6%   $��10, 25q�6B   �� 5      -   5         ��Name$ 
homeButton��5      $
��Home��6)   $��Center=�68   $��10, 35q�6U   $
��Auto��6e   $
��Auto��6r   $��5q�6�   6�   �� 5      -   5        $ createPatientButton��5      $��New Patient��62   $��Center=�6H   $��10,35q�6e   $
��Auto��6t   $
��Auto��6�   $��5q�6�   6�   �� 5      -   5        $ viewPatientsButton��5      $��View Patient Data��61   $��Center=�6M   $��10,35q�6j   $
��Auto��6y   $
��Auto��6�   $��5q�6�   6�   �� 5      -   5        $ loginLogoutButton��5      $��Login��60   $��Center=�6@   $��10,35q�6]   $
��Auto��6l   $
��Auto��6z   $
��10,5q�6�   6�   5       � 5   
   -   5        $��navFrame��5       $��1��6     � NavigationUIVisibility$ Hidden=�60   ���#e9ecef6f   5      5      