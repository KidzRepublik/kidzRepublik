import 'package:flutter/material.dart';

listbuild(BuildContext context, index,list) {
  final mQ = MediaQuery.of(context).size;
  return ListView.separated(
    separatorBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0, top: 12),
        child: Divider(
          color: Colors.grey.withOpacity(0.2),
        ),
      );
    },
    primary: false,
    shrinkWrap: true,
    itemCount: list.length,
    itemBuilder: (context, index) {
      final userData = list[index].data()
      as Map<String, dynamic>;

      return InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/staff.jpg',
//color: kprimary,
              width: mQ.width * 0.1,
              fit: BoxFit.contain,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
// crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${userData['full_name']} - ${userData['email']}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                            Colors.black87.withOpacity(0.7),
                            fontSize: 17),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(bottom: 6.0),
                        child: Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red[300],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mQ.height * 0.015,
                  ),
                  Text(
                    "Status: ${userData['status']}",
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 0.3,
                      color: Colors.black87.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Role: ${userData['role']}",
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 0.3,
                      color: Colors.black87.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Contact : ${userData['contact_number']}",
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 0.3,
                      color: Colors.black87.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}