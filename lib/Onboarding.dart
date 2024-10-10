import 'package:flutter/material.dart';
import 'package:gymm/sign%20in.dart';

import 'login.dart';


class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});

  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  'image.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                Text(
                  'We are what we do', style: TextStyle(
                    color: Color.fromARGB(1000, 63,65,78) , fontSize:30,height: 1.4,fontWeight: FontWeight.w700,)
                ),
                SizedBox(
                  height: 16
                ),
                Text('Thousand of people are usign silent moon',style:TextStyle(  color:  Colors.grey,fontWeight: FontWeight.w300,fontSize:16)),
                Text(' for smalls meditation ',style:TextStyle(  color:  Colors.grey,fontWeight: FontWeight.w300,fontSize:16)),
              SizedBox(
                height: 16
              ),
                SizedBox(
                  width:374 ,
                  height:63 ,
                  child: ElevatedButton(
                    child: Text('SIGN UP',style:TextStyle(  color:  Colors.white, fontWeight: FontWeight.w400)),
                    onPressed: () {  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: ((context) =>
                            SignUpScreen()),
                      ),
                    );},
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all( Color.fromARGB(1000, 142,151,253)),
                       // padding: WidgetStateProperty.all(EdgeInsets.all(50)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),

                      ),
                                    ),),
                ),
                SizedBox(
                    height: 16
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
              children:[
                  Text('ALREADY HAVE AN ACCOUNT?'),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: ((context) =>
                              LoginScreen()),
                        ),
                      );
                    },
                    child: Text(
                      ' LOG IN', style:TextStyle(  color: Color.fromARGB(1000, 142,151,253),fontWeight: FontWeight.w300,fontSize:16)),
                    ),
                  ]),
            ],

            ),
          ),
        ),

      ),

    );
  }
}