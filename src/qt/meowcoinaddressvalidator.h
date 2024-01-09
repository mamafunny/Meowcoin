// Copyright (c) 2011-2014 The Bitcoin Core developers
// Copyright (c) 2017-2019 The Meowcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef MEOWCOIN_QT_MEOWCOINADDRESSVALIDATOR_H
#define MEOWCOIN_QT_MEOWCOINADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class MeowcoinAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit MeowcoinAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

/** Meowcoin address widget validator, checks for a valid meowcoin address.
 */
class MeowcoinAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit MeowcoinAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

#endif // MEOWCOIN_QT_MEOWCOINADDRESSVALIDATOR_H
