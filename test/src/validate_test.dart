part of test;

testValidate() {

  group('Validator-Test', () {

    test('> isTrue', () {
      expect(() => (Validate.isTrue(true)),returnsNormally);
      expect(() => (Validate.isTrue(false)),throwsA(new isInstanceOf<ArgumentError>()));
      });

    test('> notNull', () {
      expect(() => (Validate.notNull("Test")),returnsNormally);
      expect(() => (Validate.notNull(null)),throwsA(new isInstanceOf<ArgumentError>()));
      });
    
    test('> notEmpty', () {
      expect(() => (Validate.notEmpty("Test")),returnsNormally);
      expect(() => (Validate.notEmpty([10,20])),returnsNormally);
      
      final Map<String,Object> map = new Map<String,Object>();
      expect(() => (Validate.notEmpty(map)),throwsA(new isInstanceOf<ArgumentError>()));
      
      map["Hallo"]="Test";
      expect(() => (Validate.notEmpty(map)),returnsNormally);
      
      // int has not Method "isEmpty"
      expect(() => (Validate.notEmpty(0)),throwsA(new isInstanceOf<NoSuchMethodError>()));
      
      expect(() => (Validate.notEmpty("")),throwsA(new isInstanceOf<ArgumentError>()));
      }); 
    
    test('> notBlank', () {
      expect(() => (Validate.notBlank("Test")),returnsNormally);
      expect(() => (Validate.notBlank(null)),throwsA(new isInstanceOf<ArgumentError>()));
      expect(() => (Validate.notBlank("")),throwsA(new isInstanceOf<ArgumentError>()));
      
      // Dart should point out at least a warning!!!!
      //expect(() => (Validate.notBlank(10)),throwsA(new isInstanceOf<ArgumentError>()));
      });  
    
    test('> noNullElements', () {
      expect(() => (Validate.noNullElements([1,2,3,4])),returnsNormally);
      
      final List<String> list = new List<String>()
          ..addAll(["one","two","three"]);
      
      expect(() => (Validate.noNullElements(list)),returnsNormally);
      
      list.add(null);
      expect(4,list.length);
      expect(() => (Validate.noNullElements(list)),throwsA(new isInstanceOf<ArgumentError>()));
      
      expect(() => (Validate.noNullElements(new List<String>())),returnsNormally);
      });  
    
    test('> validIndex', () {
      expect(() => (Validate.validIndex([1,2],1)),returnsNormally);
      expect(() => (Validate.validIndex([1,2],3)),throwsA(new isInstanceOf<RangeError>()));
      
      final List<String> list = new List<String>()
          ..addAll(["one","two","three"]);  
      
      expect(() => (Validate.validIndex(list,1)),returnsNormally);
      });  
    
    test('> validState', () {
      expect(() => (Validate.validState(true)),returnsNormally);
      expect(() => (Validate.validState(false)),throwsA(new isInstanceOf<IllegalStateError>()));
      });  
    
    test('> matchesPattern', () {
      expect(() => (Validate.matchesPattern("Test",new RegExp("^\\we\\w{2}\$"))),returnsNormally);
      expect(() => (Validate.matchesPattern("Te_st",new RegExp("^\\we\\w{2}\$"))),throwsA(new isInstanceOf<ArgumentError>()));
      
      expect(() => (Validate.isEmail("urbi@orbi.it")),returnsNormally);
      expect(() => (Validate.isEmail("urbi@orbit")),throwsA(new isInstanceOf<ArgumentError>()));
      
      expect(() => (Validate.isPassword("1abcdefGH#")),returnsNormally);
      expect(() => (Validate.isPassword("urbi@orbi.it")),throwsA(new isInstanceOf<ArgumentError>()));
      
      expect(() => (Validate.isAlphaNumeric("123abcdö")),returnsNormally);
      expect(() => (Validate.isAlphaNumeric("123a#bcd")),throwsA(new isInstanceOf<ArgumentError>()));  
      
      expect(() => (Validate.isHex("1234567890abcdef")),returnsNormally);
      expect(() => (Validate.isHex("0x1234567890abcdef")),returnsNormally);
      expect(() => (Validate.isHex("1234567890abcdefg")),throwsA(new isInstanceOf<ArgumentError>()));            
      }); 
    
    test('> inclusive', () {
      expect(() => (Validate.inclusiveBetween(0,2,2)),returnsNormally);
      expect(() => (Validate.inclusiveBetween(0,2,3)),throwsA(new isInstanceOf<ArgumentError>()));
      
      expect(() => (Validate.exclusiveBetween(0,2,2)),throwsA(new isInstanceOf<ArgumentError>()));
      expect(() => (Validate.exclusiveBetween(0,2,1)),returnsNormally);
      });   
    
//    test('> isInstanceOf', () {
//      expect(() => (Validate.isInstanceOf(String,"Hallo")),returnsNormally);
//      expect(() => (Validate.isInstanceOf(int,"Hallo")),throwsA(new isInstanceOf<ArgumentError>()));
//      });     
  });
}

//------------------------------------------------------------------------------------------------
// Helper
//------------------------------------------------------------------------------------------------


