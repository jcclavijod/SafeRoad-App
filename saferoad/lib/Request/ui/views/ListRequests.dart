import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Request/ui/widgets/iconEmpty.dart';

import '../../../Chat/ui/widgets/icon_empty.dart';
import '../../../Home/ui/widgets/SideMenuWidget.dart';
import '../../bloc/request/request_bloc.dart';
import '../../model/Request.dart';

class ListRequests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Viajes Finalizados'),
      ),
      drawer: const SideMenuWidget(),
      body: _buildFinishedRequestCard(context),
    );
  }
}

Widget _buildFinishedRequestCard(context) {
  final requestBloc = BlocProvider.of<RequestBloc>(context);
  requestBloc.loadListRequest();
  return BlocBuilder<RequestBloc, RequestState>(
    builder: (context, state) {
      return state.finishedRequests.isEmpty
          ? requestEmpty(context)
          : ListView.builder(
              itemCount: state.finishedRequests.length,
              itemBuilder: (context, index) {
                final request = state.finishedRequests[index];

                return _requestCard(request);
              },
            );
    },
  );
}

Widget _requestCard(DocumentSnapshot request) {
  final requestData = request.data() as Map<String, dynamic>;

  return Column(
    children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usuario: ${requestData['userId']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${requestData['status']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
