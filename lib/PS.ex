defmodule Solutions do
  #Find the last box of a list.
  def p01(list) do
      if(length(list) == 0) do
        raise("Wait !!!")
      else Enum.at(list,-1)
      end

  end
  @spec p02(list()) :: [...]
  def p02(list) do
    if(length(list) == 2 || length(list) == 0) do
      list
    else [Enum.at(list,-2),Enum.at(list,-1)]
    end
  end
  def p03(list,n) do
    Enum.at(list,n-1)
  end
  def p04(list) do
    length(list)
  end
  def p05(list) do
    Enum.reverse(list)
  end
  #Find out whether a list is a palindrome.
  #A palindrome can be read forward or backward; e.g. (x a m a x).
  def p06(list1,list2) do
    list1|> Enum.sort() == list2|> Enum.sort()
  end
  def p07(list) do
    List.flatten(list)
  end
  def p07_v1([]), do: []
  def p07_v1([ head | tail ]) do
    p07_v1(head) ++ p07_v1(tail)
  end
  def p07_v1(head), do: [head]
  #Eliminate consecutive duplicates of list elements.
  def p08(list), do: (0..(length(list)-1))|> Enum.reduce(
    {[Enum.at(list,0)],Enum.at(list,0)},
    fn i,{acc,prev_char} ->
      current_char=Enum.at(list,i)
      if(current_char != prev_char) do
        {acc ++ [current_char],current_char}
      else
        {acc,current_char}
      end

    end
    )|>elem(0)
  # Pack consecutive duplicates of list elements into sublists.
  #If a list contains repeated elements they should be placed in separate sublists.
  def p09([]), do: []
  def p09(list) do
    if(length(list) ==1) do [list]
    else
    {head,tail,_}=(1..(length(list)-1))|> Enum.reduce(

    {[],[Enum.at(list,0)],Enum.at(list,0)},
    fn i,{acc,prev_sub,prev_char} ->
      current_char=Enum.at(list,i)
      if(current_char == prev_char) do
        {acc,[current_char|prev_sub],current_char}
      else
        {acc ++ [prev_sub],[current_char],current_char}
      end
    end)
    head ++ [tail]
  end
  end
  #Use the result of problem P09 to implement the so-called run-length encoding data
  #compression method. Consecutive duplicates of elements are encoded as lists (N E)
  #where N is the number of duplicates of the element E.
  def p10(list) do
    packed_duplicates = p09(list)
    Enum.reduce(
      packed_duplicates,[],fn ls,acc ->
        acc ++[[length(ls),Enum.at(ls,0)]]
      end
    )
  end
  # Modify the result of problem P10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as (N E) lists.
  def p11(list) do
    packed_duplicates = p09(list)
    Enum.reduce(
      packed_duplicates,[],fn ls,acc ->
        len=length(ls)
        if(len == 1) do
          acc ++[[Enum.at(ls,0)]]
        else
          acc ++[[length(ls),Enum.at(ls,0)]]
        end
      end
    )
  end
  #     [["a"],[2,"b"],["c"],[2,"a"],["d"],[2,"e"]] to ["a", "b", "b", "c", "a", "a", "d", "e", "e"]
  def p12(list) do
    Enum.map(list,fn l ->
      if(length(l) == 2) do
        count= Enum.at(l,0)
        char_current=Enum.at(l,1)
        Enum.reduce(0..(count-1),[],
        fn _,acc->
          acc++[char_current]
        end
        )
      else
        l
      end
    end)|> p07()
  end
  def p14(list,n) do
    Enum.reduce(list,[],fn e,acc -> #[]
        new_char=Enum.reduce(0..(n-1),[],
        fn _,acc->
          acc++[e]
          end
        )
        acc ++ new_char

    end)
  end

  end
