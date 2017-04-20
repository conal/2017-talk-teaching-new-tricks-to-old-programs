%% -*- latex -*-

% Presentation
%\documentclass[aspectratio=1610]{beamer} % Macbook Pro screen 16:10
\documentclass{beamer} % default aspect ratio 4:3
%% \documentclass[handout]{beamer}

% \setbeameroption{show notes} % un-comment to see the notes

\input{macros}

%include polycode.fmt
%include forall.fmt
%include greek.fmt
%include formatting.fmt

\title{Teaching new tricks to old programs}
\date{May 2017}

\setlength{\blanklineskip}{1.5ex}
\setlength\mathindent{4ex}

\begin{document}

% \large

\frame{\titlepage}

\framet{What does it mean?}{ \LARGE

\vspace{6ex}

\begin{center}

> x + 2 * y

\end{center}
\vspace{6ex}

\pause
It depends on |x| and |y|.

}

\framet{What does it mean?}{ \LARGE

\vspace{6ex}

\begin{center} \mathindent0ex

> \ x y -> x + 2 * y

\end{center}
\vspace{6ex}

\pause
It depends on |+|, |*|, and |2|.

}

%format N="\mathbb{N}"
%format Z="\mathbb{Z}"
%format Q="\mathbb{Q}"
%format R="\mathbb{R}"
%format C="\mathbb{C}"

\framet{What does it mean?}{

%% \vspace{1ex}

\begin{center} \LARGE \mathindent0ex

> \ x y -> x + 2 * y

\end{center}
%% \vspace{1ex}

{\large It depends on |+|, |*|, and |2|}\pause:

\begin{itemize}\itemsep2ex
\item |Int|, |Float|, |Double|
\item |N|, |Z|, |Q|, |R|, |C|
\item Vectors, polynomials
\item Functions
\item Regular expressions
\item Arbitrary rings, semirings, \dots.
\end{itemize}

\vspace{2ex}

}

\framet{Organizing interpretations}{
\begin{itemize}\itemsep2ex\parskip1ex
\item
  Abstract algebra: interfaces and laws, e.g.,
  \begin{itemize}\itemsep2ex
  \item
    Monoid, group, ring
  \item
    Vector space
  \item
    Functor, applicative, monad, foldable, traversable
  \item
    Category, with products, with coproducts/sums
  \end{itemize}
\item
  Refactor and repurpose proofs and programs.
  (More with less.)
\end{itemize}

Example,

> fold :: (Foldable f, Monoid m) => f m -> m

}

\framet{What does it mean?}{

%% \vspace{1ex}

\begin{center} \LARGE \mathindent0ex

> \ x y -> x + 2 * y

\end{center}
%% \vspace{1ex}

\begin{itemize}\itemsep2ex
\item
  The most basic ``operations'':  |\ |, variables, and application.
\pitem
  We can't overload.
\pitem
  Or can we?
\end{itemize}

}


\framet{Why overload lambda?}{ \large

Same as algebraic abstraction:

\vspace{2ex}

\begin{itemize}\itemsep3ex
\item Convenient notation.
\item Generalized, principled interpretation.
\item Modular programming and reasoning.
\end{itemize}


}

\framet{Why overload lambda?}{

\vspace{2ex}

\begin{itemize}\itemsep1ex\parskip1.5ex
\item
 Convenient notation for functions.
\pitem
 Alternative function implementations:
 \begin{itemize}\itemsep1.5ex
 \item
   GPU code
 \item
   Circuits
 \end{itemize}
\pitem
 Enhanced functions:
 \begin{itemize}\itemsep1.5ex
 \item
   Derivatives and integrals
 \item
   Incremental evaluation
 \item
   Interval analysis
 \item
   Optimization
 \item
   Root-finding; constraint solving
 \end{itemize}
\end{itemize}

\vspace{2ex}
}

\framet{How to overload lambda?}{

\begin{itemize}\itemsep3ex\parskip1.5ex
\pitem 
  Idea: eliminate it, and overload as usual.
\pitem
  How?
\out{
\begin{itemize}\itemsep1.5ex
\item
  Write in point-free form.
\item
  Can be difficult to write and read.
\item
  Automation?
\end{itemize}
}
\end{itemize}

}

\framet{Eliminating lambda}{}

\framet{\emph{Introducing} lambda}{

\pause
\begin{code}

const :: b -> (a -> b)
const b = \ a -> b

id :: a -> a
id = \ a -> a

(.) :: (b -> c) -> (a -> b) -> (a -> c)
g . f = \ a -> g (f a)

(&&&) :: (a -> c) -> (a -> d) -> (a -> c :* d)
f &&& g = \ a -> (f a, g a)

curry :: (a :* b -> c) -> (a -> b -> c)
curry f = \ a -> \ b -> f (a,b)

apply :: ((a -> b) :* a) -> b
apply  = \ (f,a) -> f a
       = uncurry id

\end{code}

}

\out{
\framet{Eliminating lambda}{
\begin{itemize}\itemsep2ex
\item
  Function-builders: |const|, |id|, |(.)|, |(&&&)|, |curry|, |uncurry|, etc.
\item
  Systematically \emph{un-inline} these operations.
\item
  What set of operations suffices to eliminate all lambdas?
\end{itemize}
}
}

\framet{Eliminating lambda}{

Systematic \emph{un-inlining:}

%format :=> = "\dashrightarrow"

\begin{code}
(\ p -> k)         :=>  const k

(\ p -> p)         :=>  id

(\ p -> u v)       :=>  apply . ((\ p -> u) &&& (\ p -> v))

(\ p -> \ q -> u)  :=>  curry (\ (p,q) -> u)

                   :=>  curry (\ r -> u[fst r / p, snd r / q])
\end{code}

\

Automate via a compiler plugin.

}

\framet{Examples}{

\begin{code}
sqr :: Num a => a -> a
sqr a = a * a

magSqr :: Num a => a :* a -> a
magSqr (a,b) = sqr a + sqr b

cosSinProd :: Floating a => a :* a -> a :* a
cosSinProd (x,y) = (cos z, sin z) where z = x * y
\end{code}

After |\ |-elimination:

%% format cosC = cos
%% format sinC = sin
%% format addC = add
%% format mulC = mul

\begin{code}
sqr = mulC . (id &&& id)

magSqr = addC . (mulC . (exl &&& exl) &&& mulC . (exr &&& exr))

cosSinProd = (cosC &&& sinC) . mulC
\end{code}

%% \vspace{-2ex}
%% where |mulC| and |addC| are uncurried |(*)| and |(+)|.

%% \vspace{-2ex}
%% where |(*) = curry mulC| and |(+) = curry addC|.

}

%format ProductCat = Cartesian
%format CoproductCat = Cocartesian
%format ClosedCat = Closed

\out{
\framet{Abstract algebra for functions}{
\begin{itemize}\itemsep2ex
\item
  |Category|
\item
  |Cartesian|
\item
  |Closed|
\end{itemize}
}
}

\framet{Abstract algebra for functions}{

Interface:

> class Category (~>) where
>   id   :: a ~> a
>   (.)  :: (b ~> c) -> (a ~> b) -> (a ~> c)
>   infixr 9 .

Laws:

> id . f       == f
> g . id       == g
> (h . g) . f  == h . (g . f)

}

\setlength{\fboxsep}{-1ex}

\framet{Products}{

> class Category (~>) => ProductCat (~>) where
>   type Prod (~>) a b
>   exl    ::  (Prod (~>) a b) ~> a
>   exr    ::  (Prod (~>) a b) ~> b
>   (&&&)  ::  (a ~> c)  -> (a ~> d)  -> (a ~> (Prod (~>) c d))
>   infixr 3 &&&

Laws:

> exl . (f &&& g)      == f                
> exr . (f &&& g)      == g                
> exl . h &&& exr . h  == h                

}

\out{
\framet{Coproducts}{

Dual to product.

> class Category (~>) => CoproductCat (~>) where
>   type Coprod (~>) a b
>   inl    ::  a ~> (Coprod (~>) a b)
>   inr    ::  b ~> (Coprod (~>) a b)
>   (|||)  ::  (a ~> c)  -> (b ~> c)  -> ((Coprod (~>) a b) ~> c)
>   infixr 2 |||

Laws:

> (f ||| g) . inl      == f
> (f ||| g) . inr      == g
> h . inl ||| h . inr  == h

}
}

\framet{Exponentials}{

\begin{code}
class ProductCat (~>) => ClosedCat (~>) where
  type Exp (~>) a b
  apply    :: (Prod (~>) (Exp (~>) a b) a) ~> b
  curry    :: ((Prod (~>) a b) ~> c) -> (a ~> (Exp (~>) b c))
  uncurry  :: (a ~> (Exp (~>) b c)) -> ((Prod (~>) a b) ~> c)
\end{code}
Laws:

\begin{code}

uncurry (curry f)                == f
curry (uncurry g)                == g
apply . (curry f . exl &&& exr)  == f
apply == uncurry id

\end{code}

}

\framet{Changing interpretations}{
\begin{itemize}\itemsep2ex
\item
  We've eliminated lambdas and variables
\item
  and replaced them with an algebraic vocabulary.
\pitem
  What happens if we replace |(->)| with other instances?\\
  (Via compiler plugin.)
\end{itemize}
}

\framet{Computation graphs --- example}{

> magSqr (a,b) = sqr a + sqr b

> magSqr = addC . (mulC . (exl &&& exl) &&& mulC . (exr &&& exr))

\pause
\begin{center}\wpicture{4.5in}{magSqr}\end{center}
}

\framet{Computation graphs --- example}{

\vspace{-4ex}

> cosSinProd (x,y) = (cos z, sin z) where z = x * y

> cosSinProd = (cosC &&& sinC) . mulC

\begin{center}\wpicture{4.5in}{cosSinProd}\end{center}
}

\framet{Computation graphs --- implementation sketch}{

\begin{code}
data Graph a b = Graph (Ports a -> GraphM (Ports b))

type GraphM = State (Port,[Comp])

data Comp = forall a b. Comp String (Ports a) (Ports b)

instance Category Graph where
  type Ok Graph a = GenPorts a
  id = Graph return
  Graph g . Graph f = Graph (g <=< f)

instance BoolCat Graph where
  notC  = genComp  ldq not rdq
  andC  = genComp  ldq && rdq
  orC   = genComp  ldq || rdq
\end{code}

}

\framet{Computation graphs --- fold}{

> sum :: Tree N4 Int -> Int

\begin{center}\wpicture{4.5in}{sum-t4}\end{center}

}

\framet{Computation graphs --- scan}{

> lsums :: Tree N4 Int -> Tree N4 Int :* Int

\vspace{-6ex}

\begin{center}\wpicture{4.25in}{lsums-rb4}\end{center}

}

\framet{Haskell to hardware}{

Convert graphs to Verilog:

\begin{textblock}{180}[1,0](350,95)
\begin{tcolorbox}
\wpicture{2.2in}{magSqr}
\end{tcolorbox}
\end{textblock}

\begin{verbatim}
   module magSqr (In_0, In_1, Out);
     input [31:0] In_0;
     input [31:0] In_1;
     output [31:0] Out;
     wire [31:0] Plus_I0;
     wire [31:0] Times_I3;
     wire [31:0] Times_I4;
     assign Plus_I0 = Times_I3 + Times_I4;
     assign Out = Plus_I0;
     assign Times_I3 = In_0 * In_0;
     assign Times_I4 = In_1 * In_1;
   endmodule
\end{verbatim}
}

\nc\lm[1]{\mathop{\multimap}_{#1}}
%format LM a b = a "\multimap" b

\framet{Linear maps}{(maybe omit)}

%% \nc\ad[1]{\mathop{\leadsto}_{#1}}
%% %format DF s a b = a "\ad{"s"}" b
%% %format DF' s = "\ad{"s"}"

\framet{Automatic differentiation}{
\mathindent-1ex
\begin{code}
data D a b = D (a -> b :* (LM a b)) -- Derivatives are linear maps.

linearD f = D (\ a -> (f a, linear f))

instance Num s => Category D where
  id = linearD id
  D g . D f = D (\ a -> let { (b,f') = f a ; (c,g') = g b } in (c, g' . f'))

instance Num s => Cartesian D where
  exl  = linearD exl
  exr  = linearD exr
  D f &&& D g = D (\ a -> let { (b,f') = f a ; (c,g') = g a } in ((b,c), f' &&& g'))

instance Num s => NumCat D s where
  negateC  = linearD negateC
  addC     = linearD addC
  mulC     = D (mulC &&& \ (a,b) -> linear (\ (da,db) -> da * b + db * a))

\end{code}
}

\framet{Composing interpretations (|Graph| and |D|)}{

\begin{textblock}{160}[1,0](357,37)
\begin{tcolorbox}
\wpicture{2in}{magSqr}
\end{tcolorbox}
\end{textblock}

\vspace{8ex}
\begin{center}\wpicture{4.5in}{magSqr-ad}\end{center}

%% \figoneW{0.51}{cosSinProd-ad}{|andDeriv cosSinProd|}{\incpic{cosSinProd-ad}}}
}

\framet{Composing interpretations (|Graph| and |D|)}{

\begin{textblock}{165}[1,0](173,41)
\begin{tcolorbox}
\wpicture{2in}{cosSinProd}
\end{tcolorbox}
\end{textblock}

\vspace{10ex}
\begin{center}\wpicture{4.5in}{cosSinProd-ad}\end{center}
}

%% \framet{Incremental computation}{}

\framet{Interval analysis}{
\mathindent1ex
\small

%format Iv = Interval
%format IF = IFun

%format al = a"_"lo
%format ah = a"_"hi
%format bl = b"_"lo
%format bh = b"_"hi
%format min4
%format max4

\begin{code}
data IF a b = IF (Iv a -> Iv b)

type family Iv a
type instance Iv Double      = Double :* Double
type instance Iv (a  :*  b)  = Iv a  :*  Iv b
type instance Iv (a  ->  b)  = Iv a  ->  Iv b
\end{code}

\begin{minipage}[b]{0.47\textwidth}
\begin{code}
instance Category IF where
  id = IF id
  IF g . IF f = IF (g . f)
NOP
\end{code}
\end{minipage}
\begin{minipage}[b]{0ex}{\ \ \rule[1.9ex]{0.5pt}{11ex}}\end{minipage}
\begin{minipage}[b]{0.3\textwidth}\setlength\mathindent{2ex}
\begin{code}
instance Cartesian IF where
  exl = IF exl
  exr = IF exr
  IF f &&& IF g = IF (f &&& g)
\end{code}
\end{minipage}
\vspace{-7ex}
\begin{code}
...
NOP
instance (Iv a ~ (a :* a), Num a, Ord a) => NumCat IF a where
  addC = IF (\ ((al,ah),(bl,bh)) -> (al+bl,ah+bh))
  mulC = IF (\ ((al,ah),(bl,bh)) ->
    minmax [al*bl,al*bh,ah*bl,ah*bh]
  ...
\end{code}
}

\framet{Interval analysis --- example}{
\vspace{3ex}

> horner [1,3,5]

\vspace{-12ex}
\begin{center}\wpicture{4.6in}{horner-iv}\end{center}
}


\framet{Constraint solving}{}

\framet{}{}

\framet{Domain-specific languages}{ }

\end{document}
