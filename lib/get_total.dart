// fun String.findFloat(): ArrayList<Float> {
//     //get digits from result
//     if (this == null || this.isEmpty()) return ArrayList<Float>()
//     val originalResult = ArrayList<Float>()
//     val matchedResults = Regex(pattern = "[+-]?([0-9]*[.])?[0-9]+").findAll(this)
//     if (matchedResults != null)
//         for (txt in matchedResults) {
//             if (txt.value.isFloatAndWhole()) originalResult.add(txt.value.toFloat())
//         }
//     return originalResult
// }


// private fun String.isFloatAndWhole() = this.matches("\\d*\\.\\d*".toRegex())

// fun getReceipts(text: String): Receipts {
//     val originalResult = text.findFloat()
//     if (originalResult == null || originalResult.isEmpty()) return Receipts()
//     else {
//         val receipts = Receipts()
//         val totalF = Collections.max(originalResult)
//         val secondLargestF = findSecondLargestFloat(originalResult)
//         receipts.total = totalF.toString()
//         receipts.vat = if (secondLargestF == 0.0f) "0" else "%.2f".format(totalF - secondLargestF)
//         return receipts
//     }
// }

isFloatAndWhole(String txt) {
  return new RegExp("\\d*\\.\\d*").hasMatch(txt);
}

/// Get only double number
Iterable<double> getDouble(String text) {
  return new RegExp("[+-]?([0-9]*[.])?[0-9]+")
    .allMatches(text)
    .where((match) => isFloatAndWhole(match.input))
    .map((match) => double.parse(match.input));
}

/// Return the largest price in the list
getTotal(String text) {
  final prices = getDouble(text).toList();
  prices.sort((a, b) => a.compareTo(b));
  return prices.first;
}
