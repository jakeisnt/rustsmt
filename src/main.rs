use z3::{ast, Config, Context, Solver};
use z3::ast::Ast;
use z3::Model;


fn get_str_from_model<'v>(model: &Model, var: &ast::String<'v>) -> String {
    model.eval(var, true).unwrap().as_string().unwrap()
}

fn main() {
    println!("Hello, world!");
// https://blog.xaviermaso.com/2019/11/12/Use-SMT-Solvers-to-generate-crossword-grids-(2).html
    let ctx = &Context::new(&Config::default());
    let solver = Solver::new(ctx);

    // AST types here encapsulate both variablis and values; just depends on how they are created
    // this is a Z3 AST variable with the name 'horizontal'
    let horizontal = z3::ast::String::new_const(ctx, "horizontal");
    // this is an smt value with the provided value
    let abat = z3::ast::String::from_str(ctx, "abat").unwrap();
    // not sure if i agree with this representation!

    let formula = &horizontal._eq(&abat);

    print!("{}", solver.check() == z3::SatResult::Sat);
    solver.assert(formula);


    if let Some(model) = solver.get_model() {
        print!("{}", get_str_from_model(&model, &horizontal));
        print!("model: {}", model);
    } else {
        print!("nothing???");
};
}


