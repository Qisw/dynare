#ifndef _DATATREE_HH
#define _DATATREE_HH

using namespace std;

#include <string>
#include <map>
#include <list>

#include "SymbolTable.hh"
#include "NumericalConstants.hh"
#include "VariableTable.hh"
#include "ExprNode.hh"

class DataTree
{
  friend class ExprNode;
  friend class NumConstNode;
  friend class VariableNode;
  friend class UnaryOpNode;
  friend class BinaryOpNode;
protected:
  //! A reference to the symbol table
  SymbolTable &symbol_table;
  //! Reference to numerical constants table
  NumericalConstants &num_constants;
  //! The variable table
  VariableTable variable_table;
  
  typedef list<NodeID> node_list_type;
  //! The list of nodes
  node_list_type node_list;
  //! A counter for filling ExprNode's idx field
  int node_counter;

  //! Stores local parameters value
  map<int, NodeID> local_parameters_table;

  //! Computing cost above which a node can be declared a temporary term
  int min_cost;

  //! Left indexing parenthesis
  char lpar;
  //! Right indexing parenthesis
  char rpar;

  typedef map<int, NodeID> num_const_node_map_type;
  num_const_node_map_type num_const_node_map;
  typedef map<pair<int, Type>, NodeID> variable_node_map_type;
  variable_node_map_type variable_node_map;
  typedef map<pair<NodeID, int>, NodeID> unary_op_node_map_type;
  unary_op_node_map_type unary_op_node_map;
  typedef map<pair<pair<NodeID, NodeID>, int>, NodeID> binary_op_node_map_type;
  binary_op_node_map_type binary_op_node_map;

  inline NodeID AddUnaryOp(UnaryOpcode op_code, NodeID arg);
  inline NodeID AddBinaryOp(NodeID arg1, BinaryOpcode op_code, NodeID arg2);
public:
  DataTree(SymbolTable &symbol_table_arg, NumericalConstants &num_constants_arg);
  virtual ~DataTree();
  NodeID Zero, One, MinusOne;
  //! Type of output 0 for C and 1 for Matlab (default), also used as matrix index offset
  int offset;

  //! Raised when a local parameter is declared twice
  class LocalParameterException
  {
  public:
    string name;
    LocalParameterException(const string &name_arg) : name(name_arg) {}
  };

  NodeID AddNumConstant(const string &value);
  NodeID AddVariable(const string &name, int lag = 0);
  //! Adds "arg1+arg2" to model tree
  NodeID AddPlus(NodeID iArg1, NodeID iArg2);
  //! Adds "arg1-arg2" to model tree
  NodeID AddMinus(NodeID iArg1, NodeID iArg2);
  //! Adds "-arg" to model tree
  NodeID AddUMinus(NodeID iArg1);
  //! Adds "arg1*arg2" to model tree
  NodeID AddTimes(NodeID iArg1, NodeID iArg2);
  //! Adds "arg1/arg2" to model tree
  NodeID AddDivide(NodeID iArg1, NodeID iArg2);
  //! Adds "arg1^arg2" to model tree
  NodeID AddPower(NodeID iArg1, NodeID iArg2);
  //! Adds "exp(arg)" to model tree
  NodeID AddExp(NodeID iArg1);
  //! Adds "log(arg)" to model tree
  NodeID AddLog(NodeID iArg1);
  //! Adds "log10(arg)" to model tree
  NodeID AddLog10(NodeID iArg1);
  //! Adds "cos(arg)" to model tree
  NodeID AddCos(NodeID iArg1);
  //! Adds "sin(arg)" to model tree
  NodeID AddSin(NodeID iArg1);
  //! Adds "tan(arg)" to model tree
  NodeID AddTan(NodeID iArg1);
  //! Adds "acos(arg)" to model tree
  NodeID AddACos(NodeID iArg1);
  //! Adds "asin(arg)" to model tree
  NodeID AddASin(NodeID iArg1);
  //! Adds "atan(arg)" to model tree
  NodeID AddATan(NodeID iArg1);
  //! Adds "cosh(arg)" to model tree
  NodeID AddCosH(NodeID iArg1);
  //! Adds "sinh(arg)" to model tree
  NodeID AddSinH(NodeID iArg1);
  //! Adds "tanh(arg)" to model tree
  NodeID AddTanH(NodeID iArg1);
  //! Adds "acosh(arg)" to model tree
  NodeID AddACosH(NodeID iArg1);
  //! Adds "asinh(arg)" to model tree
  NodeID AddASinH(NodeID iArg1);
  //! Adds "atanh(args)" to model tree
  NodeID AddATanH(NodeID iArg1);
  //! Adds "sqrt(arg)" to model tree
  NodeID AddSqRt(NodeID iArg1);
  //! Adds "arg1=arg2" to model tree
  NodeID AddEqual(NodeID iArg1, NodeID iArg2);
  void AddLocalParameter(const string &name, NodeID value) throw (LocalParameterException);
};

inline NodeID
DataTree::AddUnaryOp(UnaryOpcode op_code, NodeID arg)
{
  unary_op_node_map_type::iterator it = unary_op_node_map.find(make_pair(arg, op_code));
  if (it != unary_op_node_map.end())
    return it->second;
  else
    return new UnaryOpNode(*this, op_code, arg);
}

inline NodeID
DataTree::AddBinaryOp(NodeID arg1, BinaryOpcode op_code, NodeID arg2)
{
  binary_op_node_map_type::iterator it = binary_op_node_map.find(make_pair(make_pair(arg1, arg2), op_code));
  if (it != binary_op_node_map.end())
    return it->second;
  else
    return new BinaryOpNode(*this, arg1, op_code, arg2);
}

#endif
