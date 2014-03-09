using System;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using MAD.Security;


namespace MAD.Controls
{
    public class LoginControl : WebControl, INamingContainer 
    {
        private TextBox userNameTextBox;
        private TextBox passwordTextBox;
        private Label userNameLabel;
        private Label passwordLabel;
        private Label errorMessageLabel;
        private CheckBox rememberMeCheckBox;
        private Button loginButton;
        private Label titleLabel;
        private ValidationSummary groupValidationSummary;

        private readonly string validationGroupName = "loginValidationGroup";

        private string emptyUserNameText;
        private string emptyPasswordText;
        private string invalidCredentialsText;

        public LoginControl() : base(HtmlTextWriterTag.Div) { }

        #region Attributes

        #region Appearance

        [Category("Appearance")]
        public string UserNameTextBoxCssClass {get; set;}

        [Category("Appearance")]
        public string UserNameLabelCssClass {get; set;}

        [Category("Appearance")]
        public string PasswordTextBoxCssClass {get; set;}

        [Category("Appearance")]
        public string PasswordLabelCssClass {get; set;}

        [Category("Appearance")]
        public string  RememberMeCheckBoxCssClass {get; set;}

        [Category("Appearance")]
        public string LoginButtonCssClass {get; set;}

        [Category("Appearance")]
        public string TitleLabelCssClass { get; set; }

        #endregion

        #region Data

        [Category("Data")]
        [DefaultValue("User name:")]
        public string UserNameLabelText
        {
            get
            {
                if (String.IsNullOrEmpty(userNameLabel.Text))
                {
                    userNameLabel.Text = "User name:";
                }
                return userNameLabel.Text;
            }
            set
            {
                userNameLabel.Text = value;
            }
        }

        [Category("Data")]
        [DefaultValue("Password:")]
        public string PasswordLabelText
        {
            get
            {
                if (String.IsNullOrEmpty(passwordLabel.Text))
                {
                    passwordLabel.Text = "Password:";
                }
                return passwordLabel.Text;
            }
            set
            {
                passwordLabel.Text = value;
            }
        }

        [Category("Data")]
        [DefaultValue("Login")]
        public string LoginButtonText
        {
            get
            {
                if (String.IsNullOrEmpty(loginButton.Text))
                {
                    loginButton.Text = "Login";
                }
                return loginButton.Text;
            }
            set
            {
                loginButton.Text = value;
            }
        }


        [Category("Data")]
        [DefaultValue("Login")]
        public string TitleLabelText
        {
            get
            {
                if (String.IsNullOrEmpty(titleLabel.Text))
                {
                    titleLabel.Text = "Login";
                }
                return titleLabel.Text;
            }
            set
            {
                titleLabel.Text = value;
            }
        }

        [Category("Data")]
        [DefaultValue("Remember me")]
        public string RememberMeCheckBoxText
        {
            get
            {
                if (String.IsNullOrEmpty(rememberMeCheckBox.Text))
                {
                    rememberMeCheckBox.Text = "Remember me";
                }
                return rememberMeCheckBox.Text;
            }
            set
            {
                rememberMeCheckBox.Text = value;
            }
        }

        [Category("Data")]
        public string InvalidCredentialsText
        {
            get
            {
                if (String.IsNullOrEmpty(invalidCredentialsText))
                {
                    invalidCredentialsText = "Invalid credentials";
                }
                return invalidCredentialsText;
            }
            set
            {
                invalidCredentialsText = value;
            }
        }

        [Category("Data")]
        public string EmptyUserNameText
        {
            get
            {
                if (String.IsNullOrEmpty(emptyUserNameText))
                {
                    emptyUserNameText = "User name can not be blank.";
                }
                return emptyUserNameText;
            }
            set
            {
                emptyUserNameText = value;
            }
        }

        [Category("Data")]
        public string EmptyPasswordText
        {
            get
            {
                if (String.IsNullOrEmpty(emptyPasswordText))
                {
                    emptyPasswordText = "Password can not be blank.";
                }
                return emptyPasswordText;
            }
            set
            {
                emptyPasswordText = value;
            }
        }

        #endregion

        #endregion

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            EnsureChildControls();
        }

        protected override void CreateChildControls()
        {
            userNameTextBox = new TextBox();
            userNameTextBox.ID = "UserNameTextBox";
            userNameTextBox.CssClass = UserNameTextBoxCssClass;

            passwordTextBox = new TextBox();
            passwordTextBox.ID = "PasswordTextBox";
            passwordTextBox.CssClass = PasswordTextBoxCssClass;
            passwordTextBox.TextMode = TextBoxMode.Password;
            
            userNameLabel = new Label();
            userNameLabel.CssClass = UserNameLabelCssClass;
            userNameLabel.AssociatedControlID = userNameTextBox.ID;
            userNameLabel.Text = UserNameLabelText;

            passwordLabel = new Label();
            passwordLabel.CssClass = PasswordLabelCssClass;
            passwordLabel.AssociatedControlID = passwordTextBox.ID;
            passwordLabel.Text = PasswordLabelText;

            errorMessageLabel = new Label();
            

            titleLabel = new Label();
            titleLabel.CssClass = TitleLabelCssClass;
            titleLabel.Text = TitleLabelText;

            rememberMeCheckBox = new CheckBox();
            rememberMeCheckBox.CssClass = RememberMeCheckBoxCssClass;
            rememberMeCheckBox.Text = RememberMeCheckBoxText;

            loginButton = new Button();
            loginButton.Text = LoginButtonText;
            loginButton.CausesValidation = true;
            loginButton.ValidationGroup = validationGroupName;
            loginButton.Click += LoginButton_Click;

            groupValidationSummary = new ValidationSummary();
            groupValidationSummary.ValidationGroup = validationGroupName;

            CreateLayout();
        }

        private void CreateLayout()
        {
            var container = new HtmlGenericControl("div");

            var p = new HtmlGenericControl("p");
            p.Controls.Add(errorMessageLabel);
            container.Controls.Add(p);

            container.Controls.Add(groupValidationSummary);

            p = new HtmlGenericControl("p");
            p.Controls.Add(titleLabel);
            container.Controls.Add(p);

            p = new HtmlGenericControl("p");
            var validator = new RequiredFieldValidator();
            validator.ControlToValidate = userNameTextBox.ID;
            validator.ValidationGroup = validationGroupName;
            validator.ErrorMessage = EmptyUserNameText;
            p.Controls.Add(userNameLabel);
            p.Controls.Add(userNameTextBox);
            p.Controls.Add(validator);
            container.Controls.Add(p);

            p = new HtmlGenericControl("p");
            validator = new RequiredFieldValidator();
            validator.ControlToValidate = passwordTextBox.ID;
            validator.ValidationGroup = validationGroupName;
            validator.ErrorMessage = EmptyPasswordText;
            p.Controls.Add(passwordLabel);
            p.Controls.Add(passwordTextBox);
            p.Controls.Add(validator);
            container.Controls.Add(p);

            p = new HtmlGenericControl("p");
            p.Controls.Add(rememberMeCheckBox);
            container.Controls.Add(rememberMeCheckBox);



            p = new HtmlGenericControl("p");
            p.Controls.Add(loginButton);
            container.Controls.Add(p);

            Controls.Add(container);
        }

        void LoginButton_Click(object sender, EventArgs e)
        {
            string userName = userNameTextBox.Text.Trim();
            string password = passwordTextBox.Text.Trim();
            bool  isPersistent = rememberMeCheckBox.Checked;
            if (MADUsers.ValidateUser(userName, password))
            {

                HttpCookie authCookie = MADUsers.CreateAuthCookie(userName, isPersistent);
                Page.Response.Cookies.Add(authCookie);

                string redirectUrl = FormsAuthentication.GetRedirectUrl(userName, isPersistent);
                Page.Response.Redirect(redirectUrl);
            }
            else
            {
                errorMessageLabel.Text = InvalidCredentialsText;
            }
        }
    }
}
