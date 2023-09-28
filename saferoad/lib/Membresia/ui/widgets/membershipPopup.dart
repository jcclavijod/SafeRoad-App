// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MembershipPopUp extends StatefulWidget {
  final VoidCallback onMembershipConfirmed;

  const MembershipPopUp({super.key, required this.onMembershipConfirmed});

  @override
  _MembershipPopUpState createState() => _MembershipPopUpState();
}

class _MembershipPopUpState extends State<MembershipPopUp> {
  int _selectedPaymentMethod = 0;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expirationDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Elige tu método de pago:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _PaymentOptionCard(
              icon: Icons.credit_card,
              title: 'Tarjeta de Crédito',
              onSelect: () {
                setState(() {
                  _selectedPaymentMethod = 0;
                });
              },
              isSelected: _selectedPaymentMethod == 0,
            ),
            const SizedBox(height: 10),
            _PaymentOptionCard(
              icon: Icons.credit_card,
              title: 'Tarjeta de Débito',
              onSelect: () {
                setState(() {
                  _selectedPaymentMethod = 1;
                });
              },
              isSelected: _selectedPaymentMethod == 1,
            ),
            const SizedBox(height: 20),
            _selectedPaymentMethod != -1
                ? Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ingresa la información de tu tarjeta:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 1),
                        TextFormField(
                          controller: _cardNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Número de tarjeta',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa el número de tarjeta';
                            }
                            final cardNumber = value.replaceAll(' ', '');
                            if (cardNumber.length != 16) {
                              return 'El número de tarjeta debe tener 16 dígitos';
                            }
                            if (!cardNumber.runes
                                .every((rune) => rune >= 48 && rune <= 57)) {
                              return 'El número de tarjeta solo debe contener números';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                          ],
                        ),
                        const SizedBox(height: 1),
                        TextFormField(
                          controller: _cardHolderController,
                          decoration: const InputDecoration(
                            labelText: 'Titular de la tarjeta',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa el titular de la tarjeta';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 1),
                        Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              controller: _expirationDateController,
                              decoration: const InputDecoration(
                                labelText: 'Fecha de caducidad',
                              ),
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa la fecha de caducidad';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (value.length == 2 && !value.contains('/')) {
                                  _expirationDateController.text = '$value/';
                                  _expirationDateController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: _expirationDateController
                                            .text.length),
                                  );
                                }
                              },
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(5),
                              ],
                            )),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _cvvController,
                                decoration: const InputDecoration(
                                  labelText: 'CVV',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingresa el CVV';
                                  }
                                  final cvvNumber = value.replaceAll(' ', '');
                                  if (cvvNumber.length != 3) {
                                    return 'El número de CVV debe tener 3 dígitos';
                                  }
                                  if (!cvvNumber.runes.every(
                                      (rune) => rune >= 48 && rune <= 57)) {
                                    return 'El número de tarjeta solo debe contener números';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                widget.onMembershipConfirmed();
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Pagar'),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onSelect;
  final bool isSelected;

  const _PaymentOptionCard({
    required this.icon,
    required this.title,
    required this.onSelect,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      onTap: onSelect,
    );
  }
}
