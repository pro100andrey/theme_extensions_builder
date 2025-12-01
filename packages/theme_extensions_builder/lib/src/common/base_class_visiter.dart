import 'package:analyzer/dart/element/element.dart';

/// Base class for visiting Dart element nodes in the AST.
///
/// This class extends [ElementVisitor2] and provides empty implementations
/// for all visitor methods. Subclasses should override specific methods
/// to implement custom visiting behavior.
///
/// Commonly used by code generators to traverse class elements and extract
/// information about fields, methods, and other class members.
class BaseClassVisitor extends ElementVisitor2<void> {
  @override
  void visitFieldElement(FieldElement element) {}

  @override
  void visitClassElement(ClassElement element) {}

  @override
  void visitConstructorElement(ConstructorElement element) {}

  @override
  void visitEnumElement(EnumElement element) {}

  @override
  void visitExtensionElement(ExtensionElement element) {}

  @override
  void visitExtensionTypeElement(ExtensionTypeElement element) {}

  @override
  void visitFieldFormalParameterElement(FieldFormalParameterElement element) {}

  @override
  void visitFormalParameterElement(FormalParameterElement element) {}

  @override
  void visitGenericFunctionTypeElement(GenericFunctionTypeElement element) {}

  @override
  void visitGetterElement(GetterElement element) {}

  @override
  void visitLabelElement(LabelElement element) {}

  @override
  void visitLibraryElement(LibraryElement element) {}

  @override
  void visitLocalFunctionElement(LocalFunctionElement element) {}

  @override
  void visitLocalVariableElement(LocalVariableElement element) {}

  @override
  void visitMethodElement(MethodElement element) {}

  @override
  void visitMixinElement(MixinElement element) {}

  @override
  void visitMultiplyDefinedElement(MultiplyDefinedElement element) {}

  @override
  void visitPrefixElement(PrefixElement element) {}

  @override
  void visitSetterElement(SetterElement element) {}

  @override
  void visitSuperFormalParameterElement(SuperFormalParameterElement element) {}

  @override
  void visitTopLevelFunctionElement(TopLevelFunctionElement element) {}

  @override
  void visitTopLevelVariableElement(TopLevelVariableElement element) {}

  @override
  void visitTypeAliasElement(TypeAliasElement element) {}

  @override
  void visitTypeParameterElement(TypeParameterElement element) {}
}
