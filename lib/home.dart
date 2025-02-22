import 'package:flutter/material.dart';

import 'utils/utils.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final Utils utils = Utils();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Spicy Spoon'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Spicy_spoon.png',
              height: screenHeight * 0.25,
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            SizedBox(
              width: screenWidth * 0.35,
              child: TextField(
                // controller: loginController.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: utils.textColor),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: utils.textColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            SizedBox(
              width: screenWidth * 0.35,
              child: TextField(
                // controller: loginController.emailController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: utils.textColor),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: utils.textColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            SizedBox(
              height: 45,
              width: screenWidth * 0.35,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  backgroundColor: utils.buttonColor,
                ),
                onPressed: () {},
                child: const Text(
                  'Login',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
