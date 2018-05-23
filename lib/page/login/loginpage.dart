import 'package:meta/meta.dart';

import 'package:flutter/material.dart';

import 'package:beer_me_up/common/widget/loadingwidget.dart';
import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/materialraisedbutton.dart';
import 'package:beer_me_up/common/widget/materialflatbutton.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';

const String LOGIN_PAGE_ROUTE = "/login";

class LoginPage extends StatefulWidget {
  final LoginIntent intent;
  final LoginViewModel model;

  LoginPage._({
    Key key,
    @required this.intent,
    @required this.model}) : super(key: key);

  factory LoginPage({Key key,
    LoginIntent intent,
    LoginViewModel model,
    AuthenticationService userService}) {

    final _intent = intent ?? LoginIntent();
    final _model = model ?? LoginViewModel(
      userService ?? AuthenticationService.instance,
      _intent.showSignIn,
      _intent.showSignUp,
      _intent.signUp,
      _intent.signIn,
      _intent.signInWithGoogle,
      _intent.signUpWithGoogle,
      _intent.signInWithFacebook,
      _intent.signUpWithFacebook,
      _intent.forgotPassword,
      _intent.signUpEmailInputChanged,
      _intent.signUpPasswordInputChanged,
      _intent.signInEmailInputChanged,
      _intent.signInPasswordInputChanged,
      _intent.privacyPolicyClicked,
    );

    return LoginPage._(key: key, intent: _intent, model: _model);
  }

  @override
  _LoginPageState createState() => _LoginPageState(intent: intent, model: model);
}

class _LoginPageState extends ViewState<LoginPage, LoginViewModel, LoginIntent, LoginState> {

  final signUpEmailController = TextEditingController();
  final signUpPassController = TextEditingController();
  final signInEmailController = TextEditingController();
  final signInPassController = TextEditingController();

  _LoginPageState({
    @required LoginIntent intent,
    @required LoginViewModel model
  }): super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<LoginState> snapshot) {
        if( !snapshot.hasData ) {
          return Container();
        }

        return snapshot.data.join(
          (signUp) => _buildSignUpScreen(context),
          (signIn) => _buildLoginScreen(context),
          (authenticating) => _buildAuthenticatingScreen(context),
          (signUpError) => _buildSignUpScreen(context, error: signUpError.error),
          (signInError) => _buildLoginScreen(context, error: signInError.error),
        );
      },
    );
  }

  Widget _buildSignUpScreen(BuildContext context, {String error}) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Create your account",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22.0,
                    fontFamily: "Google Sans",
                  ),
                ),
                Offstage(
                  offstage: error == null,
                  child: Column(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.only(top: 16.0)),
                      Text(
                        error ?? "",
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 16.0)),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: signUpEmailController,
                  onChanged: (val) { intent.signUpEmailInputChanged(); },
                ),
                const Padding(padding: EdgeInsets.only(top: 16.0)),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  controller: signUpPassController,
                  onChanged: (val) { intent.signUpPasswordInputChanged(); },
                ),
                const Padding(padding: EdgeInsets.only(top: 25.0)),
                Center(
                  child: MaterialRaisedButton.primary(
                    context: context,
                    onPressed: () { intent.signUp(LoginFormData(signUpEmailController.text, signUpPassController.text)); },
                    text: "Sign-up"
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 25.0)),
                InkWell(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.lock,
                        color: Colors.blueGrey[900],
                        size: 22.0,
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10.0)),
                      const Expanded(
                        child: Text(
                          "Like privacy? We feel you. We don’t use or sell your data. Touch to read our privacy policy.",
                          style: TextStyle(
                            fontSize: 14.0,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: intent.privacyPolicyClicked,
                ),
                const Padding(padding: EdgeInsets.only(top: 25.0)),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 2.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).textTheme.title.color,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
                    const Text(
                      "OR",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Google Sans",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
                    Expanded(
                      child: Container(
                        height: 2.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).textTheme.title.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 25.0)),
                Center(
                  child: MaterialRaisedButton.primary(
                    context: context,
                    onPressed: intent.signUpWithGoogle,
                    text: "Sign-in with Google",
                    leading: Image.asset("images/google.png"),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 16.0)),
                Center(
                  child: MaterialRaisedButton.primary(
                    context: context,
                    onPressed: intent.signUpWithFacebook,
                    text: "Sign-in with Facebook",
                    leading: Image.asset("images/facebook.png"),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30.0)),
                Center(
                  child: MaterialFlatButton.primary(
                    context: context,
                    onPressed: intent.showSignIn,
                    text: "Already have an account? Sign-in",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginScreen(BuildContext context, {String error}) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Sign-in with your account",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22.0,
                        fontFamily: "Google Sans",
                      ),
                    ),
                    Offstage(
                      offstage: error == null,
                      child: Column(
                        children: <Widget>[
                          const Padding(padding: EdgeInsets.only(top: 16.0)),
                          Text(
                            error ?? "",
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 16.0)),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: signInEmailController,
                      onChanged: (val) { intent.signInEmailInputChanged(); },
                    ),
                    const Padding(padding: EdgeInsets.only(top: 16.0)),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Password",
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: signInPassController,
                      onChanged: (val) { intent.signInPasswordInputChanged(); },
                    ),
                    const Padding(padding: EdgeInsets.only(top: 25.0)),
                    Center(
                      child: MaterialRaisedButton.primary(
                          context: context,
                          onPressed: () { intent.signIn(LoginFormData(signInEmailController.text, signInPassController.text)); },
                          text: "Sign-in"
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 16.0)),
                    Center(
                      child: MaterialFlatButton.primary(
                          context: context,
                          onPressed: () { intent.forgotPassword(context); },
                          text: "Forgot password?"
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20.0)),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 2.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).textTheme.title.color
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 16.0)),
                        const Text(
                          "OR",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Google Sans",
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 16.0)),
                        Expanded(
                          child: Container(
                            height: 2.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).textTheme.title.color
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 25.0)),
                    Center(
                      child: MaterialRaisedButton.primary(
                        context: context,
                        onPressed: intent.signInWithGoogle,
                        text: "Sign-in with Google",
                        leading: Image.asset("images/google.png"),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 16.0)),
                    Center(
                      child: MaterialRaisedButton.primary(
                        context: context,
                        onPressed: intent.signInWithFacebook,
                        text: "Sign-in with Facebook",
                        leading: Image.asset("images/facebook.png"),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30.0)),
                    Center(
                      child: MaterialFlatButton.primary(
                        context: context,
                        onPressed: intent.showSignUp,
                        text: "Don't have an account yet? Sign-up",
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildAuthenticatingScreen(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: LoadingWidget(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Image.asset("images/toolbar_icon.png"),
      centerTitle: true,
    );
  }
}